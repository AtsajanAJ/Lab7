const express = require('express');
const bodyParser = require('body-parser');
const grpc = require('@grpc/grpc-js');
const protoLoader = require('@grpc/proto-loader');

const app = express();
const PORT = process.env.PORT || 8000;
const PLUGIN_HOST = process.env.PLUGIN_HOST || 'clicker-plugin';
const PLUGIN_PORT = process.env.PLUGIN_PORT || 50001;

// Production: Disable CORS (handled by API Gateway)
app.use(bodyParser.json());

// Load proto file for gRPC client
const PROTO_PATH = __dirname + '/clicker.proto';
const OPTIONS = {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
};

const packageDefinition = protoLoader.loadSync(PROTO_PATH, OPTIONS);
const clicker_proto = grpc.loadPackageDefinition(packageDefinition).Clicker;

// Create gRPC client to connect to Plugin
const pluginClient = new clicker_proto(
  `${PLUGIN_HOST}:${PLUGIN_PORT}`,
  grpc.credentials.createInsecure()
);

/**
 * API Endpoint: POST /api/click
 * Front-End → Back-End (HTTP/REST) → Plugin (gRPC)
 */
app.post('/api/click', (req, res) => {
  const currentCount = req.body.currentCount || 0;
  
  console.log(`[Backend] Received click request with count: ${currentCount}`);
  console.log(`[Backend] Calling Plugin via gRPC...`);
  
  // Call Plugin via gRPC
  pluginClient.handleClick(
    { currentCount: currentCount },
    (error, response) => {
      if (error) {
        console.error('[Backend] Error calling plugin:', error);
        return res.status(500).json({
          error: 'Failed to call plugin',
          message: error.message
        });
      }
      
      console.log(`[Backend] Plugin returned new count: ${response.newCount}`);
      
      // Return response to Front-End
      res.json({
        newCount: response.newCount,
        message: 'Click processed successfully'
      });
    }
  );
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.json({ status: 'ok', service: 'clicker-backend' });
});

app.listen(PORT, () => {
  console.log(`🚀 Clicker Backend (API Gateway) running on port ${PORT}`);
  console.log(`📡 Plugin connection: ${PLUGIN_HOST}:${PLUGIN_PORT}`);
});


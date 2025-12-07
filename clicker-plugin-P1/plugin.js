const PROTO_PATH = "./clicker.proto";
const OPTIONS = {
  keepCase: true,
  longs: String,
  enums: String,
  defaults: true,
  oneofs: true,
};

const grpc = require('@grpc/grpc-js');
const protoLoader = require('@grpc/proto-loader');

const packageDefinition = protoLoader.loadSync(PROTO_PATH, OPTIONS);
const clicker_proto = grpc.loadPackageDefinition(packageDefinition);

/**
 * Plugin P1: เพิ่มตัวเลขขึ้น 2
 * Version: P1
 */
function onHandleClick(call, callback) {
  const currentCount = call.request.currentCount;
  
  // Plugin P1 Logic: เพิ่มขึ้น 2
  const newCount = currentCount + 2;
  
  console.log(`[Plugin P1] Received count: ${currentCount}, Returning: ${newCount} (incremented by 2)`);
  
  callback(null, {
    newCount: newCount,
  });
}

const server = new grpc.Server();
server.addService(clicker_proto.Clicker.service, {
  handleClick: onHandleClick,
});

server.bindAsync(
  `0.0.0.0:${process.env.PLUGIN_PORT || 50001}`,
  grpc.ServerCredentials.createInsecure(),
  () => {
    console.log(`🚀 Clicker Plugin P1 (gRPC Server) started at 0.0.0.0:${process.env.PLUGIN_PORT || 50001}`);
    console.log(`📡 Plugin Logic: Increment by 2`);
  }
);


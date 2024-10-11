-include .env

deploy base:
	forge script script/DeployHelloUSDCBase.s.sol:DeployHelloUSDCBase --rpc-url $(BASE_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
deploy op:
	forge script script/DeployHelloUSDCOp.s.sol:DeployHelloUSDCOp --rpc-url $(OP_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
# run-base-script:
# 	forge script script/ScriptBaseSepolia.s.sol:ScriptBaseSepolia --rpc-url $(BASE_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
base sepolia:
	forge script script/BaseSepolia.s.sol:BaseSepolia --rpc-url $(BASE_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

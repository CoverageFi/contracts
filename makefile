-include .env

deploy-cross-chain-sender:
	forge script script/DeployCrossChainSender.s.sol:DeployCrossChainSender --rpc-url $(BASE_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
deploy-cross-chain-receiver:
	forge script script/DeployCrossChainReceiver.s.sol:DeployCrossChainReceiver --rpc-url $(OP_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
run-base-script:
	forge script script/ScriptBaseSepolia.s.sol:ScriptBaseSepolia --rpc-url $(BASE_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

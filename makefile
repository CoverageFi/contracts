-include .env

deploy-cross-chain-sender:
	forge script script/DeployCrossChainSender.s.sol:DeployCrossChainSender --rpc-url $(ETH_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
deploy-cross-chain-receiver:
	forge script script/DeployCrossChainReceiver.s.sol:DeployCrossChainReceiver --rpc-url $(BASE_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
run-sepolia-script:
	forge script script/ScriptETHSepolia.s.sol:ScriptETHSepolia --rpc-url $(ETH_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast

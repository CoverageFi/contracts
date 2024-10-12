-include .env

deploy sender on sepolia:
	forge script script/DeployCrossChainSender.s.sol:DeployCrossChainSender --rpc-url $(ETH_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast -vvvv
deploy receiver on arb sepolia:
	forge script script/DeployCrossChainReceiver.s.sol:DeployCrossChainReceiver --rpc-url $(ARB_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
deploy receiver on avalanche fuji:
	forge script script/DeployCrossChainReceiver.s.sol:DeployCrossChainReceiver --rpc-url $(AVALANCHE_FUJI_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast
deploy wallet abstraction on sepolia:
	forge script script/DeployWalletAbstraction.s.sol:DeployWalletAbstraction --rpc-url $(ETH_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast --verify
run-sepolia-script:
	forge script script/ScriptETHSepolia.s.sol:ScriptETHSepolia --rpc-url $(ARB_SEPOLIA_RPC_URL) --private-key $(PRIVATE_KEY) --broadcast -vvv

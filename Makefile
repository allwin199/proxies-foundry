-include .env

.PHONY: deployToAnvil deployToSepolia generateTestReport upgradeBoxOnAvil upgradeBoxOnSepolia
# .phoney describes all the command are not directories

# Including @ will not display the acutal command in terminal
# The backslash (\) is used as a line continuation 

deployToAnvil:
	@forge script script/DeployBox.s.sol:DeployBox --rpc-url $(ANVIL_RPC_URL) --account $(ACCOUNT_FOR_ANVIL) --sender $(ANVIL_KEYCHAIN) --broadcast

deployToSepolia:
	@forge script script/DeployBox.s.sol:DeployBox --rpc-url $(SEPOLIA_RPC_URL) --account $(ACCOUNT_FOR_SEPOLIA) --sender $(SEPOLIA_KEYCHAIN) --broadcast --verify $(ETHERSCAN_API_KEY)

upgradeBoxOnAvil:
	@forge script script/UpgradeBox.s.sol:UpgradeBox --rpc-url $(ANVIL_RPC_URL) --account $(ACCOUNT_FOR_ANVIL) --sender $(ANVIL_KEYCHAIN) --broadcast	

upgradeBoxOnSepolia:
	@forge script script/UpgradeBox.s.sol:UpgradeBox --rpc-url $(SEPOLIA_RPC_URL) --account $(ACCOUNT_FOR_SEPOLIA) --sender $(SEPOLIA_KEYCHAIN) --broadcast --verify $(ETHERSCAN_API_KEY)


generateTestReport :;
	@rm -rf coverage; \
	forge coverage --report lcov; \
	genhtml lcov.info --output-directory coverage; \
	open coverage/index.html; \
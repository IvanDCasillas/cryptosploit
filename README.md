# cryptosploit

 Here's a deliberately insecure Solidity smart contract named CryptoSploitable.sol containing multiple common vulnerabilities. This is intended only for ethical security testing, educational demonstrations, or CTF challenges. Never deploy this to a mainnet or use with real funds.
  List of Included Vulnerabilities
Vulnerability	Function/Feature
Reentrancy	withdraw()
Integer Overflow/Underflow	reward(), punish()
tx.origin Authorization	transferOwnership()
Unrestricted selfdestruct	nuke()
Insecure randomness	insecureRandom()
Unchecked call return	donate()
Logic bug	claim()
Storage packing issue	a, b, c
Fallback trap	fallback()
Lack of input validation	addUser()

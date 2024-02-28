- Proxies are the truest form of upgrades.
- Proxies use lot of low level functionality.
- `delegatecall` is one of them

- Proxy Terminology
- 1. The Implementation Contract
  - Which has all our code of our protocol. When we upgrade, we launch a brand new implementation contract.
- 2. The Proxy Contract
  - Which points to which implementation is the "correct" one, and routes everyone's function calls to that contract.
- 3. The User
  - The user makes calls to the proxy
- 4. The admin
  - This is the admin (or group of users/voters) who upgrade to new implementation contracts.

- Note: All the storage variables are stored in the "Proxy" contract and not in the "Implementation" contract.
- This way when we upgrade to a new implementation all our data will stay in the "Proxy" contract
- If we want to add a new storage variable, we can add it in the "Implementation" contract and "Proxy" contract will pick it up. 

- Gotchas:
- 1. Storage Clashes
- 2. Function Selector Clashes

-------

- Proxy Patterns
- UUPS (Universal Upgradable Proxy Pattern)

https://youtu.be/wUjYK5gwNZs?t=18139
GiftLock Smart Contract

The **GiftLock** smart contract is a decentralized Clarity-based solution that enables users to **lock STX as a timed gift** for a chosen recipient. The recipient can only claim the gift after the specified unlock block, ensuring trustless and transparent gift delivery on the Stacks blockchain.

---

 Features
- **Timed Gifting** – Lock STX for a recipient until a chosen unlock block.  
- **Unlock Mechanism** – Recipient claims the gift only after the unlock time.  
- **Secure Transfers** – Prevents premature withdrawals by enforcing block conditions.  
- **Transparency** – All gift details (giver, recipient, amount, unlock block) are recorded on-chain.  
- **Optional Cancellation** – Giver can cancel and reclaim STX before the unlock time (if unclaimed).  

---

 Functions

Public Functions
- `create-gift (recipient principal) (unlock-block uint) (amount uint)`  
  Create a new gift by locking STX until the specified unlock block.  

- `claim-gift (id uint)`  
  Recipient claims the gift after the unlock block has passed.  

- `cancel-gift (id uint)`  
  Giver cancels the gift before it is claimed (only allowed before unlock).  

Read-Only Functions
- `get-gift (id uint)`  
  View the details of a specific gift.  

- `gift-status (id uint)`  
  Check whether a gift is **active**, **claimed**, or **cancelled**.  

---

 Deployment
1. Clone this repository.  
2. Install [Clarinet](https://github.com/hirosystems/clarinet).  
3. Run tests:  
   ```bash
   clarinet test

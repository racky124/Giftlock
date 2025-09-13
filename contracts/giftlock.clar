;; ------------------------------------------------
;; Contract: gift-lock
;; Time-Locked STX Gifting Contract
;; ------------------------------------------------

(define-constant ERR_ALREADY_EXISTS (err u100))
(define-constant ERR_NO_GIFT (err u101))
(define-constant ERR_TOO_EARLY (err u102))
(define-constant ERR_NOT_RECIPIENT (err u103))

;; Store gift details
(define-map gifts
  { id: uint }
  { sender: principal, recipient: principal, amount: uint, unlock-height: uint, claimed: bool })

;; ------------------------------
;; Public Functions
;; ------------------------------

;; Create a time-locked gift
(define-public (create-gift (id uint) (recipient principal) (unlock-height uint) (amount uint))
  (if (is-some (map-get? gifts { id: id }))
      ERR_ALREADY_EXISTS
      (begin
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set gifts { id: id }
          { sender: tx-sender, recipient: recipient, amount: amount, unlock-height: unlock-height, claimed: false })
        (ok true))))

;; Claim the gift after unlock height
(define-public (claim-gift (id uint))
  (match (map-get? gifts { id: id })
    gift-data
      (if (not (is-eq (get recipient gift-data) tx-sender))
          ERR_NOT_RECIPIENT
          (if (< stacks-block-height (get unlock-height gift-data))
              ERR_TOO_EARLY
              (if (get claimed gift-data)
                  ERR_NO_GIFT
                  (begin
                    (map-set gifts { id: id }
                      { sender: (get sender gift-data), recipient: (get recipient gift-data),
                        amount: (get amount gift-data), unlock-height: (get unlock-height gift-data), claimed: true })
                    (stx-transfer? (get amount gift-data) (as-contract tx-sender) tx-sender)))))
    ERR_NO_GIFT))

;; ------------------------------
;; Read-Only Functions
;; ------------------------------

;; Check gift details
(define-read-only (get-gift (id uint))
  (map-get? gifts { id: id }))

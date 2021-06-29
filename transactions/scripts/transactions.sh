# You must edit the values of MYWALLET and PEM_FILE
# and then modify the TRANSACTIONS list.

MYWALLET="erd1eff5kt2zccg3z2numg9e7a5fnzphrq8rpr4l98j92u78djxvtdgs79set8"
PEM_FILE="~/elrond/transactions/pemFiles/emiElrond"

declare -a TRANSACTIONS=(
  "erd1jsyvz2qa7a3sntyz4m2sjz6uwcjc2duqcxvg0s9wmtzkuwpg3utqc4a07x 0.007423"    #emi binance
)

# DO NOT MODIFY ANYTHING FROM HERE ON
PROXY="https://api.elrond.com"
DENOMINATION="1000000000000000000"

# We recall the nonce of the wallet
NONCE=$(erdpy account get --nonce --address="$MYWALLET" --proxy="$PROXY")

function send-bulk-tx {
  for transaction in "${TRANSACTIONS[@]}"; do
    set -- $transaction

    echo "Reciever: $1"
    echo "Amount: $2"

    VALUE=$(expr $2*$DENOMINATION | bc) #multiply the amount to be send in eGLD by the denomination
    AMOUNT=${VALUE%.*} #get rid of the decimal part

    echo "AMOUNT" $AMOUNT

    erdpy --verbose tx new --send --chain "1" --outfile="bon-mission-tx-$NONCE.json" --pem=$PEM_FILE --nonce=$NONCE --receiver=$1 --value="$AMOUNT" --gas-limit=50000 --proxy=$PROXY
    echo "Transaction sent with nonce $NONCE and backed up to bon-mission-tx-$NONCE.json."
    (( NONCE++ ))
  done
}
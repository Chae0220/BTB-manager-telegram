#!/bin/bash
DATABASE=../binance-trade-bot/data/crypto_trading.db
while read p; do
   jumps=$(sqlite3 $DATABASE "select count(id) from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE';")
   if [[ $jumps -gt 0 ]]
   then
     first_value=$(sqlite3 $DATABASE "select alt_trade_amount from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE' order by id asc limit 1;")
     last_value=$(sqlite3 $DATABASE "select alt_trade_amount from trade_history where alt_coin_id='$p' and selling=0 and state='COMPLETE' order by id DESC limit 1;")
     
     grow=$(awk "BEGIN {print ($last_value/$first_value*100)-100}")
     echo "$p: $grow %"
   fi
done <../binance-trade-bot/supported_coin_list

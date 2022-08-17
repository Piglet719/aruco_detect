## Tokens

|ID|meaning|
|:-|:-|
|1|add|
|2|arrayJ|
|3|arrayPlus|
|4|arrayLength|
|5|arrayLengthInloop|
|6|boat|
|7|define|
|8|if|
|9|ifCon|
|10|iPlus|
|11|jPlus|
|12|repeat|
|13|setArray|
|14|setArrayPlus|
|15|setBoat|
|16|setI|
|17|setJ|
|18|swap|
|19|10|
|20|7|
|21|3|
|22|1|
|23|6|

## Grammer

setID := setBoat | setArray | setArrayPlus | setI | setJ

ID := arrayJ | boat | arrayPlus

TIME := arrayLength | arrayLengthInloop

stats := setID ID | add INT | if ifCon swap | repeat TIME

funcdef := define stats

plus := iPlus | jPlus

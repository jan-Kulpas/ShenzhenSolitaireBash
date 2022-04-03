#!/bin/bash

#░░░░░ OBSOLETE ░░░░░
# None :>
#░░░░░ SETUP ░░░░░
makeDeck () { # Make array with numbers 1..40
  local i
  for i in {1..40}
  do
    deck[$i]=$i
  done
}
shuffleDeck () { # Shuffle deck array using pickCard
  local i
  for i in {1..40}
  do
    pickCard
    tmpDeck[$i]=$picked
  done
  deck=("${tmpDeck[@]}")
}
pickCard () { # Pick random card from deck and remove it
  local randomCard

  while true
  do
    randomCard=$(( ( RANDOM % 40 ) + 1 ))

    if [ ${deck[$randomCard]} -ne 0 ] ; then
      picked=${deck[$randomCard]}
      deck[$picked]=0
      return $picked
    fi
  done
}
dealTable () { # Deal cards to columns
  local i
  for i in {0..4}
  do
    col1[$i]=${deck[8*i+0]};
    col2[$i]=${deck[8*i+1]};
    col3[$i]=${deck[8*i+2]};
    col4[$i]=${deck[8*i+3]};
    col5[$i]=${deck[8*i+4]};
    col6[$i]=${deck[8*i+5]};
    col7[$i]=${deck[8*i+6]};
    col8[$i]=${deck[8*i+7]};
  done
}
resetTableTop () { # Sets tablue and foundation values to default
  tableau=(41 41 41)
  dragons=(false false false)
  textMod=("" "" "")
  foundation=(43 44 44 44)
}
#░░░░░ GETTERS ░░░░░
getCol () { # Return column of index $1
  case $1 in
    1 ) retCol=(${col1[@]}) ;;
    2 ) retCol=(${col2[@]}) ;;
    3 ) retCol=(${col3[@]}) ;;
    4 ) retCol=(${col4[@]}) ;;
    5 ) retCol=(${col5[@]}) ;;
    6 ) retCol=(${col6[@]}) ;;
    7 ) retCol=(${col7[@]}) ;;
    8 ) retCol=(${col8[@]}) ;;
    * ) echo "Column out of range: $1"; exit 1 ;;
  esac
}
setCol () { # Set index $2 of column $1 to $3 (or 44 when removing last card)
  local setVal=$3
  # Quick fix so the last spot turns to the empty texture instead of nothing
  if [[ $2 -eq 0 && -z $3 ]]; then
    setVal=44
  fi
  case $1 in
    1 ) col1[$2]=$setVal ;;
    2 ) col2[$2]=$setVal ;;
    3 ) col3[$2]=$setVal ;;
    4 ) col4[$2]=$setVal ;;
    5 ) col5[$2]=$setVal ;;
    6 ) col6[$2]=$setVal ;;
    7 ) col7[$2]=$setVal ;;
    8 ) col8[$2]=$setVal ;;
    * ) echo "Column out of range: $1"; exit 1 ;;
  esac
}
getCardText () { # Returns array containing lines of the card to print
  case "$1" in
    "") retCard=("     " "     " "     " "     ") ;; # Empty
    1 ) retCard=("╭───╮" "|\e[91m1 🀙\e[0m|" "|\e[91m 🀙 \e[0m|" "╰───╯") ;; # 1-9 Red
    2 ) retCard=("╭───╮" "|\e[91m2 🀚\e[0m|" "|\e[91m 🀚 \e[0m|" "╰───╯") ;;
    3 ) retCard=("╭───╮" "|\e[91m3 🀛\e[0m|" "|\e[91m 🀛 \e[0m|" "╰───╯") ;;
    4 ) retCard=("╭───╮" "|\e[91m4 🀜\e[0m|" "|\e[91m 🀜 \e[0m|" "╰───╯") ;;
    5 ) retCard=("╭───╮" "|\e[91m5 🀝\e[0m|" "|\e[91m 🀝 \e[0m|" "╰───╯") ;;
    6 ) retCard=("╭───╮" "|\e[91m6 🀞\e[0m|" "|\e[91m 🀞 \e[0m|" "╰───╯") ;;
    7 ) retCard=("╭───╮" "|\e[91m7 🀟\e[0m|" "|\e[91m 🀟 \e[0m|" "╰───╯") ;;
    8 ) retCard=("╭───╮" "|\e[91m8 🀠\e[0m|" "|\e[91m 🀠 \e[0m|" "╰───╯") ;;
    9 ) retCard=("╭───╮" "|\e[91m9 🀡\e[0m|" "|\e[91m 🀡 \e[0m|" "╰───╯") ;;
    10|11|12|13 ) retCard=("╭───╮" "|\e[91mD 🀪\e[0m|" "|\e[91m 🀪 \e[0m|" "╰───╯") ;; # Red Dragons
    14 ) retCard=("╭───╮" "|\e[92m1 🀐\e[0m|" "|\e[92m 🀐 \e[0m|" "╰───╯") ;; #1-9 Green
    15 ) retCard=("╭───╮" "|\e[92m2 🀑\e[0m|" "|\e[92m 🀑 \e[0m|" "╰───╯") ;;
    16 ) retCard=("╭───╮" "|\e[92m3 🀒\e[0m|" "|\e[92m 🀒 \e[0m|" "╰───╯") ;;
    17 ) retCard=("╭───╮" "|\e[92m4 🀓\e[0m|" "|\e[92m 🀓 \e[0m|" "╰───╯") ;;
    18 ) retCard=("╭───╮" "|\e[92m5 🀔\e[0m|" "|\e[92m 🀔 \e[0m|" "╰───╯") ;;
    19 ) retCard=("╭───╮" "|\e[92m6 🀕\e[0m|" "|\e[92m 🀕 \e[0m|" "╰───╯") ;;
    20 ) retCard=("╭───╮" "|\e[92m7 🀖\e[0m|" "|\e[92m 🀖 \e[0m|" "╰───╯") ;;
    21 ) retCard=("╭───╮" "|\e[92m8 🀗\e[0m|" "|\e[92m 🀗 \e[0m|" "╰───╯") ;;
    22 ) retCard=("╭───╮" "|\e[92m9 🀘\e[0m|" "|\e[92m 🀘 \e[0m|" "╰───╯") ;;
    23|24|25|26 ) retCard=("╭───╮" "|\e[92mD 🀅\e[0m|" "|\e[92m 🀅 \e[0m|" "╰───╯") ;; # Green Dragons
    27 ) retCard=("╭───╮" "|\e[2m1 🀇\e[0m|" "|\e[2m 🀇 \e[0m|" "╰───╯") ;; # 1-9 Black
    28 ) retCard=("╭───╮" "|\e[2m2 🀈\e[0m|" "|\e[2m 🀈 \e[0m|" "╰───╯") ;;
    29 ) retCard=("╭───╮" "|\e[2m3 🀉\e[0m|" "|\e[2m 🀉 \e[0m|" "╰───╯") ;;
    30 ) retCard=("╭───╮" "|\e[2m4 🀊\e[0m|" "|\e[2m 🀊 \e[0m|" "╰───╯") ;;
    31 ) retCard=("╭───╮" "|\e[2m5 🀋\e[0m|" "|\e[2m 🀋 \e[0m|" "╰───╯") ;;
    32 ) retCard=("╭───╮" "|\e[2m6 🀌\e[0m|" "|\e[2m 🀌 \e[0m|" "╰───╯") ;;
    33 ) retCard=("╭───╮" "|\e[2m7 🀍\e[0m|" "|\e[2m 🀍 \e[0m|" "╰───╯") ;;
    34 ) retCard=("╭───╮" "|\e[2m8 🀎\e[0m|" "|\e[2m 🀎 \e[0m|" "╰───╯") ;;
    35 ) retCard=("╭───╮" "|\e[2m9 🀏\e[0m|" "|\e[2m 🀏 \e[0m|" "╰───╯") ;;
    36|37|38|39 ) retCard=("╭───╮" "|\e[2mD 🀆\e[0m|" "|\e[2m 🀆 \e[0m|" "╰───╯") ;; # Black Dragons
    40 ) retCard=("╭───╮" "|\e[95mF 🀢\e[0m|" "|\e[95m 🀢 \e[0m|" "╰───╯") ;; # Flower Card
    41 ) retCard=("╭╌╌╌╮" "╎   ╎" "╎   ╎" "╰╌╌╌╯") ;; # Empty Tableau
    42 ) retCard=("     " " \e[91m${textMod[0]}🀪\e[0;92m${textMod[1]}🀅\e[0;2m${textMod[2]}🀆\e[0m " "     " "     ") ;; # Dragon Buttons
    43 ) retCard=("╭╌╌╌╮" "╎\e[2m⠸⡾ \e[0m╎" "╎\e[2m ⡧⠒\e[0m╎" "╰╌╌╌╯") ;; # Empty Flower Space
    44 ) retCard=("╭╌╌╌╮" "╎\e[2m⢕⢕⢕\e[0m╎" "╎\e[2m⢕⢕⢕\e[0m╎" "╰╌╌╌╯") ;; # Empty Foundation/Column
    * ) retCard=("╭───╮" "│\e[94m▚▚▚\e[0m│" "│\e[94m▚▚▚\e[0m│" "╰───╯") ;; # Facedown Card
  esac
}
getCardVal () { # Returns $retRank and $retSuit
  local card=$1
  if [ $card -lt 1 -o $card -gt 45 ] ; then
     echo "Card value out of range: $card"
     exit 1
  fi

  retSuit="$(( ( ( $card - 1) / 13 ) + 1))"
  retRank="$(( $card % 13 ))"
  # 1-3 is normal suits, 4 is flower suit
  # Rank is just the value of the card or 11 if theres a letter on it

  # Hard sets the dragon and flower rank to 11 so they dont stack to 9's
  if [[ $retRank -gt 9 || $retRank -eq 0 || $retSuit -eq 4 ]]; then
    retRank=11
  fi
}
getTopCards () { # Return $retTopCards : array of top cards in each column (0 indexed)
  retTopCards=()
  local i
  for i in {1..8}
  do
    getCol $i
    local size=${#retCol[@]}
    retTopCards+=(${retCol[$size-1]})
  done
}
#░░░░░ RENDER ░░░░░
printTableIndex () { # Prints all the card values instead of ascii art
  local i
  local j
  local str="a"
  while [[ !(-z "${str// }") ]]
  do
    str=""
    for j in {1..8} #for each column append part of card in that column
    do
      getCol $j
      str+="${retCol[i]} "
    done
    echo "$str"
    ((i++))
  done
}
printTableTop () { # Prints tableau and foundation
  local i
  local j

  echo "              Wincount: $wincount"

  for i in 0 1 2 3 # All 4 lines (full card)
  do
    str='' #clear str after printing line
    for j in ${tableau[0]} ${tableau[1]} ${tableau[2]} 42 ${foundation[0]} ${foundation[1]} ${foundation[2]} ${foundation[3]} #for each column append part of card in that column
    do
      getCardText $j
      str+="${retCard[$i]}"
    done
    echo -e "$str"
  done
}
printTable () { # Prints all the cards on the table
  local i
  local j
  local k
  local str="a"
  while [[ !(-z "${str// }") ]] #loop until printed string with just whitespace
  do
    for j in 0 1 #two lines per row
    do
      str='' #clear str after printing line
      for k in {1..8} #for each column append part of card in that column
      do
        getCol $k
        if [[ $i -eq ${#retCol[@]} ]]; then #if already printed last card in column
          getCardText ${retCol[$i-1]}
          str+="${retCard[$j+2]}" #append bottom part of card
        else
          getCardText ${retCol[$i]}
          str+="${retCard[$j]}" #else append top part of card
        fi
      done
      echo -e "$str" #print full line
    done
    ((i++))
  done
}
#░░░░░ CARD LOGIC ░░░░░
handleInput () { # Reads and formats input until a proper input is provided
  while [[ true ]]; do
    echo "Select $1 Stack:"
    read retInput
    retInput=${retInput::2}
    retInput=${retInput^^}
    if [[ $retInput == "Q" ]]; then # Quit game if 'Q' entered
      exit
    fi
    if [[ $retInput =~ $pattern ]]; then # Match to the regex pattern
      return
    fi
    echo "Stack does not exist"
  done
}
winCheck () { # Check if won game
  local i
  for i in ${tableau[@]} # Check if all piles in tableau are facedown
  do
    if [[ $i -ne 45 ]]; then
      return
    fi
  done
  for i in ${foundation[@]} # Check if all foundation piles are 9's or flowers
  do
    getCardVal $i
    if [[ $retRank -ne 9 && $i -ne 40 ]]; then
      return
    fi
  done
  ((wincount++)) # Increase wincount
  printTableTop # Print the table again so it looks nice
  printTable
  echo "You Won! :)" # All conditions were met. Congratulations!
  echo $wincount > $file # Update save data.
  exit 0
}
dragonCheck () { # Checks if the Dragons can be removed from play
  local dragonSum=(0 0 0) # Array to count Dragon Cards

  getTopCards

  local i
  for i in ${tableau[@]} ${retTopCards[@]} # Goes through tableau and top cards to check if card is dragon
  do
    getCardVal $i
    if [[ $retRank -eq 11 && $retSuit -lt 4 ]]; then
      ((dragonSum[$retSuit-1]++))
    fi
  done

  for i in 0 1 2 # Updates the Dragon bools if all 4 are present
  do
    if [[ ${dragonSum[$i]} -ge 4 ]]; then
      dragons[$i]=true
      textMod[$i]="\e[7m"
    else
      dragons[$i]=false
      textMod[$i]=""
    fi
  done
}
C2C () { # Column to Column movement
  getCol $1 #Get Origin Column
  local origCol=(${retCol[@]})
  local origSize=${#origCol[@]}
  local origCard=${origCol[$origSize-1]}

  if [[ $origCard -gt 40 ]]; then # If empty stack: return
    retError="There's nothing to move"
    return
  fi

  getCol $2 # Get Destination Column
  local destCol=(${retCol[@]})
  local destSize=${#destCol[@]}
  local destCard=${destCol[$destSize-1]}

  local moveFlag=true # Flag if move is legal
  local i=0;

  getCardVal $destCard # Constant Card Value to compare
  local destRank=$retRank
  local destSuit=$retSuit

  while true # Legal check loop
  do
    getCardVal $origCard # New Card Value to compare
    local origRank=$retRank
    local origSuit=$retSuit

    if [[ $origSuit -ne $destSuit && $origRank -eq $destRank-1 ]]; then # If card can be moved on destination card, end loop and move
      moveFlag=true
      break
    elif [[ $origSize-1-i -lt 0 ]]; then # If reached end of column without moving, end loop and dont move
      retError="Can't move that here"
      moveFlag=false
      break
    fi
    ((i++))
    origCard=${origCol[$origSize-1-i]} # Get next card in column
    getCardVal $origCard
    if [[ !($retSuit -ne $origSuit && $retRank -eq $origRank+1) ]]; then # If next card doesnt stack with previous one, end loop and dont move
      retError="Can't move that here"
      moveFlag=false
      ((i--))
      break
    fi
  done

  local emptyFlag=0 # Index modifier for when moving onto empty column so it replaces the texture

  if [[ $destCard -eq 44 ]]; then # Handle break because destination was empty so no match was found
    # It's not obvious how many cards need to be moved if theres no target card
    if [[ $i -gt 0 ]]; then # But it is obvious when the only possible option was one card
      local k
      echo "Select amount of cards to move: "
      read k
      ((k--))
      if [[ $k -gt $i || $k -lt 0 ]]; then # Already counted how big the max legal stack is so check if the input is in that range
        retError="Can't move that many cards"
        return
      fi
      i=$k # Update $i for the movement loop
    fi
    retError="" # Unsets $retError from failed loop before
    emptyFlag=1 # Toggles the index modifier
    moveFlag=true
  fi

  if $moveFlag; then # Movement loop
    local j
    for ((j=0;j<=i;j++))
    do
      setCol $2 $((destSize-emptyFlag+j)) ${origCol[$origSize-1-i+j]}
      setCol $1 $((origSize-1-i+j)) ""
    done
  fi
}
C2T () { # Column to Tableau movement
  getCol $1
  local size=${#retCol[@]}
  local topCard=${retCol[$size-1]}
  local targetPile=${tableau[$2-1]}

  if [[ $topCard -gt 40 ]]; then # Empty pile
    retError="There's nothing to move"
  elif [[ $targetPile -eq 41 ]]; then # Check if destination empty
    tableau[$2-1]=$topCard
    setCol $1 $((size-1)) ""
  else # Destination full
    retError="Tableau spot is already full"
  fi
}
C2F () { # Column to Foundation movement
  getCol $1
  local size=${#retCol[@]}
  local topCard=${retCol[$size-1]}
  local targetPile=${foundation[$2]}

  if [[ $topCard -gt 40 ]]; then # Empty Pile
    retError="There's nothing to move"
  elif [[ $2 -gt 0 ]]; then # Handle placing to normal foundation
    getCardVal $topCard
    local topRank=$retRank
    local topSuit=$retSuit
    getCardVal $targetPile

    if [[ ($targetPile -eq 44 && $topRank -eq "1") || # Ace to empty space
    ($topSuit -eq $retSuit && $topRank -eq $retRank+1) ]] # Normal card on 1 lower
    then
      foundation[$2]=$topCard
      setCol $1 $((size-1)) ""
    else
      retError="Can't move that here"
    fi
  else # Handle placing to flower pile
    if [[ $topCard -eq 40 && $targetPile -eq 43 ]]; then
      foundation[0]=40
      setCol $1 $((size-1)) ""
    else
      retError="Can't move that here"
    fi
  fi
}
T2C () { # Tableau to Column movement
  local originPile=${tableau[$1-1]}
  getCol $2
  local size=${#retCol[@]}
  local topCard=${retCol[$size-1]}

  getCardVal $topCard
  local topRank=$retRank
  local topSuit=$retSuit
  getCardVal $originPile

  if [[ $originPile -gt 40 ]]; then # Empty pile
    retError="There's nothing to move"
  elif [[ $topCard -eq 44 ]]; then # Handle movement to empty column
    setCol $2 $((size-1)) $originPile
    tableau[$1-1]=41
  elif [[ $retSuit -ne $topSuit && $retRank -eq $topRank-1 ]]; then
    setCol $2 $size $originPile
    tableau[$1-1]=41
  else
    retError="Can't move that here"
  fi
}
T2T () { # Tableau to Tableau movement?
  local originPile=${tableau[$1-1]}
  local targetPile=${tableau[$2-1]}

  if [[ $originPile -gt 40 ]]; then # Empty pile
    retError="There's nothing to move"
  elif [[ $targetPile -eq 41 ]]; then # Check if destination empty
    tableau[$2-1]=$originPile
    tableau[$1-1]=41
  else # Destination full
    retError="Tableau spot is already full"
  fi
}
T2F () { # Tableau to Foundation movement
  local originPile=${tableau[$1-1]}
  local targetPile=${foundation[$2]}

  if [[ $originPile -gt 40 ]]; then # Empty Pile
    retError="There's nothing to move"
  elif [[ $2 -gt 0 ]]; then # Handle placing to normal foundation
    getCardVal $originPile
    local topRank=$retRank
    local topSuit=$retSuit
    getCardVal $targetPile

    if [[ ($targetPile -eq 44 && $topRank -eq "1") || # Ace to empty space
    ($topSuit -eq $retSuit && $topRank -eq $retRank+1) ]] # Normal card on 1 lower
    then
      foundation[$2]=$originPile
      tableau[$1-1]=41
    else
      retError="Can't move that here"
    fi
  else # Handle placing to flower pile
    if [[ $originPile -eq 40 && $targetPile -eq 43 ]]; then
      foundation[0]=40
      tableau[$1-1]=41
    else
      retError="Can't move that here"
    fi
  fi
}
D2T () { # Removal of Dragon Cards
  if ${dragons[$1-1]}; then # Check if all the dragons are available
    getCardVal ${tableau[$2-1]}
    if [[ ${tableau[$2-1]} -eq 41 || ($retRank -eq 11 && $retSuit -eq $1) ]]; then # Check if target tableau spot is available
      local i
      for i in {1..8} # Remove all dragons in columns
      do
        getCol $i
        local size=${#retCol[@]}
        getCardVal ${retCol[$size-1]}
        if [[ $retRank -eq 11 && $retSuit -eq $1 ]]; then
          setCol $i $((size-1)) ""
        fi
      done
      for i in 0 1 2 # Remove all dragons in tableau
      do
        getCardVal ${tableau[$i]}
        if [[ $retRank -eq 11 && $retSuit -eq $1 ]]; then
          tableau[$i]=41
        fi
      done
      tableau[$2-1]=45 # Lock the target spot
    else
      retError="Spot already occupied by a non-matching card"
    fi
  else
    retError="Not all dragons of that suit were unconvered"
  fi
}
#░░░░░ GETOPTS ░░░░░
help () {
  __help="For rules run using -r

To play, input the stack you want to move and then the place you want to move it to using the 2-character codes on chart below (not case sensitive).
You will be asked for the amount of cards to move if more than one move is valid with given input.

                 ┌─DRAGON BUTTONS
                 │
╔═══TABLEAU═══╗  │  ╔════FOUNDATION════╗
╭───╮╭───╮╭───╮ ┌┴┐ ╭───╮╭───╮╭───╮╭───╮
|T 1||T 2||T 3| DDD |F 0||F 1||F 2||F 3|
|   ||   ||   | 123 |   ||   ||   ||   |
╰───╯╰───╯╰───╯     ╰───╯╰───╯╰───╯╰───╯
╭───╮╭───╮╭───╮╭───╮╭───╮╭───╮╭───╮╭───╮
|C 1||C 2||C 3||C 4||C 5||C 6||C 7||C 8|
|   ||   ||   ||   ||   ||   ||   ||   |
╰───╯╰───╯╰───╯╰───╯╰───╯╰───╯╰───╯╰───╯
╚═══════════════COLUMNS════════════════╝

To collapse all dragons of a suit to tableau spot input D[1-3] depending on suit and then choose a tableau spot.

Input Q at any time to quit."
  echo "$__help"
  exit 0
}
version () {
  __version="Author           : Krzysztof Kulpiński ( s184368@student.pg.edu.pl )
Created On       : 17.05.21
Last Modified By : Krzysztof Kulpiński ( s184368@student.pg.edu.pl )
Last Modified On : 31.05.21
Version          : 1.0

Description      : Shenzhen Solitaire for linux terminal

Licensed under GPL (see /usr/share/common-licenses/GPL for more details
or contact # the Free Software Foundation for a copy)"
  echo "$__version"
  exit 0
}
rules () {
  if which xdg-open > /dev/null; then
    xdg-open "https://shenzhen-io.fandom.com/wiki/Shenzhen_Solitaire"
  elif which gnome-open > /dev/null; then
    gnome-open "https://shenzhen-io.fandom.com/wiki/Shenzhen_Solitaire"
  else
    echo "Failed to open browser automatically
    Please go to https://shenzhen-io.fandom.com/wiki/Shenzhen_Solitaire"
  fi
  exit 0
}

#▒▒▒▒▒ EXPERIMENTAL ▒▒▒▒▒
# None :<
#▒▒▒▒▒ MAIN INITIALIZATION ▒▒▒▒▒

while getopts hvr opt; # Extra parameters
do
  case $opt in
    h ) help ;;
    v ) version ;;
    r ) rules ;;
    * ) exit 1 ;;
  esac
done

resize -s 40 40

file="~/Documents/ShenzhenSolitaire/wincount.txt"
file=`eval echo $file` # Get save path

pattern="(C[1-8])|(T[1-3])|(F[0-3])|(D[1-3])" # Regex pattern for filtered input
patternFunc="C2C|C2T|C2F|T2C|T2T|T2F|D2T" # Regex pattern for valid commands

if [[ -f $file ]]; then # Load save data if it exists
  wincount=$(cat "$file")
else
  wincount=0
fi

makeDeck
shuffleDeck
dealTable

resetTableTop

#▒▒▒▒▒ MAIN LOOP ▒▒▒▒▒

while true
do
  clear # Render screen

  winCheck

  dragonCheck
  printTableTop
  printTable

  echo $retError
  retError="" # Clear error message

  handleInput "Origin"
  orig=$retInput

  handleInput "Destination"
  dest=$retInput

  if [[ $orig == $dest ]]; then # Ignore moves to itself to avoid unexpected behavior
    continue
  fi

  command="${orig::1}2${dest::1}" # Make function name from the two inputs
  if [[ $command =~ $patternFunc ]]; then # Match to the regex pattern
    $command ${orig:1} ${dest:1}  # Call function if valid funtion
  elif [[ ${orig::1} == "F" ]]; then
    retError="Can't move cards from foundation pile"
  else
    retError="Invalid command"
  fi
done

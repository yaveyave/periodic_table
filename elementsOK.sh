#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

PRUEBA=$1

CONSULTA(){
   if [[ -z $PRUEBA ]] 
   then
      echo Please provide an element as an argument.
   else
      if [[ $PRUEBA =~ ^[0-9]+$ ]]
      then
         QUER=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = '$PRUEBA'")
      else
         QUER=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol = '$PRUEBA' OR name ='$PRUEBA'")
      fi   
      if [[ -z "$QUERY" ]]
      then   
         echo $QUER | while IFS='|' read ATO_NUM SYM NAME
         do
            FULL_QUERY=$($PSQL "SELECT properties.atomic_number, types.type ,atomic_mass, melting_point_celsius,  boiling_point_celsius, properties.type_id FROM properties INNER JOIN elements ON properties.atomic_number = elements.atomic_number  INNER JOIN types ON properties.type_id = types.type_id WHERE properties.atomic_number = $ATO_NUM")
            if [[ ! -z "$FULL_QUERY" ]]
            then
               echo $FULL_QUERY | while IFS='|' read A T AM MPC BPC TP
               do
                  echo "The element with atomic number $ATO_NUM is $NAME ($SYM). It's a $T, with a mass of $AM amu. $NAME has a melting point of $MPC celsius and a boiling point of $BPC celsius."
               done   
            else 
               echo "I could not find that element in the database."
            fi
         done
      else
         echo "I could not find that element in the database."
      fi
   fi
}

CONSULTA
#Oscar

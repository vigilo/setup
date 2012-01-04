#!/bin/sh

echo "Création des exchanges sur le bus AMQP"

nodes=(
    event
    correlation
    perf
    state
    nagios
    command
    statistics
    computation-order
)

for i in `seq 1 ${#nodes[@]}`; do
    echo -n ${nodes[$i-1]}' '
    # @TODO: Le mot de passe (-p) devrait être personnalisable
    # et ne devrait pas apparaître sur la ligne de commandes.
    vigilo-bus-config -u vigilo-admin@localhost -p vigilo-admin create-exchange ${nodes[$i-1]}
done

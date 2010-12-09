#!/bin/sh

echo "Création des nœuds sur le bus XMPP"

nodes=(
    /vigilo/event
    /vigilo/correvent
    /vigilo/aggr
    /vigilo/delaggr
    /vigilo/perf
    /vigilo/state
    /vigilo/nagios
    /vigilo/statistics
)

for i in `seq 1 ${#nodes[@]}`; do
    # @TODO: Le mot de passe (-p) devrait être personnalisable
    # et ne devrait pas apparaître sur la ligne de commandes.
    vigilo-pubsub-config -a create-node -u vigilo-admin@localhost -p vigilo-admin -t ${nodes[$i-1]}
    echo -n '.'
done
echo ""

Setup
=========

Setup est un module permettant de configurer les différentes applications
requises par Vigilo.

Pour les détails du fonctionnement du Setup, se reporter à la
`documentation officielle`_.

Setup est un composant de Vigilo_.


Dépendances
-----------
Ce composant nécessite les logiciels suivants:
    - Nagios_
    - RabbitMQ_
    - snmpd_
    - NRPE_
    - httpd_
    - memcached_
    - PostgreSQL_
    - vigilo-vigiconf
    - vigilo-vigiconf-local
    - vigilo-connector-nagios
    - vigilo-connector-metro
    - vigilo-correlator

Installation
------------
L'installation se fait par la commande ``make`` (depuis un compte utilisateur
non privilégié) suivie de la commande ``make install`` (exécutée depuis le
compte super-utilisateur ``root``).


License
-------
Setup est sous licence `GPL v2`_.


.. _documentation officielle: Vigilo_
.. _Vigilo: http://www.projet-vigilo.org
.. _Nagios: http://nagios.org
.. _httpd: http://httpd.apache.org/
.. _RabbitMQ: http://www.rabbitmq.com/
.. _PostgreSQL: http://www.postgresql.org
.. _memcached: http://memcached.org/
.. _NRPE: http://exchange.nagios.org/directory/Addons/Monitoring-Agents/NRPE-%252D-Nagios-Remote-Plugin-Executor/details
.. _snmpd: http://net-snmp.sourceforge.net/
.. _`GPL v2`: ttp://www.gnu.org/licenses/gpl-2.0.html

.. vim: set syntax=rst fileencoding=utf-8 tw=78 :

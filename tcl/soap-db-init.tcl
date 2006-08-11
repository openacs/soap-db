# packages/soap-db/tcl/soap-db-init.tcl

ad_library {
    
    SOAP DB initialization procs.
    
    @author Derick Leony (derickleony@galileo.edu)
    @creation-date 2006-02-06
    @arch-tag: 62785192-82d4-4508-81f0-e77d79653a31
    @cvs-id $Id$
}

# WS declaration
SOAP::create DBString \
    -proxy {http://udbgw.galileo.edu/soap/action?service=udbgw} \
    -action {http://udbgw.openacs.org/action/udbgw.DBString} \
    -uri {http://udbgw.openacs.org/type} \
    -params { query string }

SOAP::create DB0Or1Row \
    -proxy {http://udbgw.galileo.edu/soap/action?service=udbgw} \
    -action {http://udbgw.openacs.org/action/udbgw.DB0Or1Row} \
    -uri {http://udbgw.openacs.org/type} \
    -params { query string }

SOAP::create DBListOfLists \
    -proxy {http://udbgw.galileo.edu/soap/action?service=udbgw} \
    -action {http://udbgw.openacs.org/action/udbgw.DBListOfLists} \
    -uri {http://udbgw.openacs.org/type} \
    -params { query string }

SOAP::create DBListOfArrays \
    -proxy {http://udbgw.galileo.edu/soap/action?service=udbgw} \
    -action {http://udbgw.openacs.org/action/udbgw.DBListOfArrays} \
    -uri {http://udbgw.openacs.org/type} \
    -params { query string }

SOAP::create DBList \
    -proxy {http://udbgw.galileo.edu/soap/action?service=udbgw} \
    -action {http://udbgw.openacs.org/action/udbgw.DBList} \
    -uri {http://udbgw.openacs.org/type} \
    -params { query string }

SOAP::create DBDml \
    -proxy {http://udbgw.galileo.edu/soap/action?service=udbgw} \
    -action {http://udbgw.openacs.org/action/udbgw.DBDml} \
    -uri {http://udbgw.openacs.org/type} \
    -params { query string }


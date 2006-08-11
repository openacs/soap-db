# packages/soap-db/tcl/soap-db-procs.tcl

ad_library {
    
    SOAP-DB Library.
    
    @author Derick Leony (derickleony@galileo.edu)
    @creation-date 2006-02-08
    @arch-tag: 32ec84b8-ebc3-440b-a186-612231e9efca
    @cvs-id $Id$
}

namespace eval soap_db {}

ad_proc -public soap_db::db_string {
    {-dbn ""}
    statement_name
    query
    args
} { 
    @author Derick Leony (derickleony@galileo.edu)
    @creation-date 2006-02-08
    
    @param dbn

    @param query_name

    @param query

    @param args

    @return 
    
    @error 
} {
    set full_name [db_qd_get_fullname $statement_name]
    set query [db_qd_replace_sql $full_name $query]
    set query [uplevel [list subst -nobackslashes $query]]
    set result [DBString $query]
    return $result
}


ad_proc -public soap_db::db_0or1row {
    {-dbn ""}
    statement_name
    query
} { 
    @author Derick Leony (derickleony@galileo.edu)
    @creation-date 2006-02-08
    
    @param dbn

    @param query_name

    @param query

    @return 
    
    @error 
} {
    set full_name [db_qd_get_fullname $statement_name]
    set query [db_qd_replace_sql $full_name $query]
    set query [uplevel [list subst -nobackslashes $query]]
    set row [DB0Or1Row $query]
    set result [lindex $row 0]
    foreach {field value} [lindex $row 1] {
	upvar $field aux
	set aux $value
    }
    return $result
}


ad_proc -public soap_db::db_1row {
    {-dbn ""}
    statement_name
    query
} { 
    @author Derick Leony (derickleony@galileo.edu)
    @creation-date 2006-02-08
    
    @param dbn

    @param query_name

    @param query

    @return 
    
    @error 
} {
    set full_name [db_qd_get_fullname $statement_name]
    set query [db_qd_replace_sql $full_name $query]
    set query [uplevel [list subst -nobackslashes $query]]
    set row [DB0Or1Row $query]

    set result [lindex $row 0]
    if { !$result } {
        return -code error "Query did not return any rows."
    }

    foreach {field value} [lindex $row 1] {
	upvar $field aux
	set aux $value
    }
    return $result
}


ad_proc -public soap_db::db_list_of_lists {
     {-dbn ""}
     statement_name
     query
 } {
     @author Derick Leony (derickleony@galileo.edu)
     @creation-date 2006-03-26
     
     @param dbn

     @param statement_name

     @param query

     @return 
     
     @error 
} {
    set full_name [db_qd_get_fullname $statement_name]
    set query [db_qd_replace_sql $full_name $query]
    set query [uplevel [list subst -nobackslashes $query]]
    set list_of_lists [DBListOfLists $query]
    
    return $list_of_lists
}


ad_proc -public soap_db::db_multirow {
    {-dbn ""}
    {-extend ""}
    -local:boolean
    {-ulevel 1}
    multirow_name
    statement_name
    query
    {code ""}
} {
    @author Derick Leony (derickleony@galileo.edu)
    @creation-date 2006-02-08
    
    @param dbn

    @param statement_name

    @param query

    @param extend

    @return 
    
    @error 
} {
    if {$local_p} {
	set level $ulevel
    } else {
	set level \#[template::adp_level]
    }
    set full_name [db_qd_get_fullname $statement_name]
    set query [db_qd_replace_sql $full_name $query]
    set query [uplevel [list subst -nobackslashes $query]]
    set list_of_rows [DBListOfArrays $query]

    if {[llength $list_of_rows]} {
	array set header [lindex $list_of_rows 0]
	upvar $level ${multirow_name}:columns columns
	set columns [array names header]
	foreach field $extend {
	    lappend columns $field
	}
    }

    set rownum 1
    
    foreach rowlist $list_of_rows {
	foreach {field value} $rowlist {
	    upvar 1 $field aux
	    set aux $value
	}
	uplevel 1 $code
	foreach field $extend {
	    upvar 1 $field aux
	    if {![info exists aux]} {
		set aux {}
	    }
	    lappend rowlist $field $aux
	}
	lappend rowlist rownum $rownum
	upvar $level ${multirow_name}:$rownum row
	array set row $rowlist
	incr rownum
    }

    upvar $level ${multirow_name}:rowcount rowcount
    set rowcount [expr $rownum-1]

}

ad_proc -public soap_db::db_list {
    {-dbn ""}
    statement_name
    query
} { 
    @author Derick Leony (derickleony@galileo.edu)
    @creation-date 2006-02-28
    
    @param dbn

    @param query_name

    @param query

    @return 
    
    @error 
} {
    set full_name [db_qd_get_fullname $statement_name]
    set query [db_qd_replace_sql $full_name $query]
    set query [uplevel [list subst -nobackslashes $query]]
    set result [DBList $query]
    return $result
}

ad_proc -public soap_db::db_foreach {
     {-dbn ""}
     statement_name
     query
     {code ""}
 } {
     @author Derick Leony (derickleony@galileo.edu)
     @creation-date 2006-03-26
     
     @param dbn

     @param statement_name

     @param query

     @param code

     @return 
     
     @error 
} {
    set full_name [db_qd_get_fullname $statement_name]
    set query [db_qd_replace_sql $full_name $query]
    set query [uplevel [list subst -nobackslashes $query]]
    set list_of_rows [DBListOfArrays $query]

    foreach rowlist $list_of_rows {
	foreach {field value} $rowlist {
	    upvar 1 $field aux
	    set aux $value
	}
	uplevel 1 $code
    }    
}


ad_proc -public soap_db::db_dml {
    {-dbn ""}
    statement_name
    query
    args
} { 
    @author Derick Leony (derickleony@galileo.edu)
    @creation-date 2006-02-08
    
    @param dbn

    @param query_name

    @param query

    @param args

    @return 
    
    @error 
} {
    set full_name [db_qd_get_fullname $statement_name]
    set query [db_qd_replace_sql $full_name $query]
    set query [uplevel [list subst -nobackslashes $query]]
    set result [DBDml $query]
}


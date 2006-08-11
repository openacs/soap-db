# packages/soap-db/tcl/test/soap-db-procs.tcl

ad_library {
    
    Test cases for DB SOAP
    
    @author Derick Leony (derickleony@galileo.edu)
    @creation-date 2006-02-09
    @arch-tag: 9d4f6a74-baf3-456a-8abb-9a7481dbece9
    @cvs-id $Id$
}


aa_register_case \
    -cats {smoke api production_safe} \
    -procs {soap_db::db_string} \
    soap_db_string \
    {
        A simple test that compares date and name gotten with SOAP DB API.
    } {

	set date_db [db_string -dbn udb get_date "select sysdate from dual"]
	set carnets [db_list -dbn udb get_carnets "select carnet from caalumnostb"]
	set carnet [lindex $carnets [expr "round(floor(rand() * [llength $carnets]))"]]
	set name_db [db_string -dbn udb get_date "select nombre1||' '||nombre2||' '||apellido1||' '||apellido2 from caalumnostb where carnet = :carnet"]

        aa_run_with_teardown \
            -test_code  {

		# date test test
		aa_log "Testing date to be $date_db"
		set date_soap [soap_db::db_string -dbn udb get_date "select sysdate from dual"]
		aa_true "Date obtained successfully." [string eq $date_db $date_soap]

		aa_log "Testing name of carnet $carnet to be $name_db"
		set name_soap [soap_db::db_string -dbn udb get_date \
				   "select nombre1||' '||nombre2||' '||apellido1||' '||apellido2 from caalumnostb where carnet = '$carnet'"]
		aa_true "Name obtained successfully." [string eq $name_db $name_soap]

            }
    }

aa_register_case \
    -cats {smoke api production_safe} \
    -procs {soap_db::db_0or1row} \
    soap_db_0or1row \
    {
        A simple test that compares date and name gotten with db_0or1row from SOAP DB API.
    } {

	set date_db [db_string -dbn udb get_date "select sysdate from dual"]
	set carnets [db_list -dbn udb get_carnets "select carnet from caalumnostb"]
	set carnet [lindex $carnets [expr "round(floor(rand() * [llength $carnets]))"]]
	db_0or1row -dbn udb get_date "select nombre1 as n1d, nombre2 as n2d, apellido1 as a1d, apellido2 as a2d from caalumnostb where carnet = :carnet"
	set random_string [ad_generate_random_string]
	set unchanged $random_string

        aa_run_with_teardown \
            -test_code  {

		# date test test
		aa_log "Testing date to be $date_db"
		set date_result [soap_db::db_0or1row -dbn udb get_date "select sysdate as date_soap from dual"]
		aa_true "Date query returned 1." $date_result
		aa_true "Date obtained successfully." [string eq $date_db $date_soap]

		aa_log "Testing name of carnet $carnet: $n1d $n2d $a1d $a2d"
		set name_result [soap_db::db_0or1row -dbn udb get_date \
				     "select nombre1 as n1s, nombre2 as n2s, apellido1 as a1s, apellido2 as a2s from caalumnostb where carnet = '$carnet'"]
		aa_true "Name query returned 1" $name_result
		aa_true "nombre1 obtained successfully." [string eq $n1d $n1s]
		aa_true "nombre2 obtained successfully." [string eq $n2d $n2s]
		aa_true "apellido1 obtained successfully." [string eq $a1d $a1s]
		aa_true "apellido2 obtained successfully." [string eq $a2d $a2s]

		set no_result [soap_db::db_0or1row -dbn udb get_no_data "select sysdate as nonexsistant, sysdate as unchanged from dual where 1=0"]
		aa_false "No rows query returned 0." $no_result
		aa_false "No rows query didn't create a non existant variable." [info exists nonexistant]
		aa_true "No rows query didn't change initial value of a variable." [string eq $random_string $unchanged]

            }
    }

aa_register_case \
    -cats {smoke api production_safe} \
    -procs {soap_db::db_multirow} \
    soap_db_multirow \
    {
        A simple test that compares multirows obtained from SOAP DB API.
    } {

	set carnets [db_list -dbn udb get_carnets "select carnet from caalumnostb"]
	set carnet [lindex $carnets [expr "round(floor(rand() * [llength $carnets]))"]]

	db_multirow -dbn udb -extend {extra} mrd get_carrs "select carrera, pensum from caalumcarrstb where carnet = '$carnet'" {
	    set extra "$carrera||$pensum"
	}

        aa_run_with_teardown \
            -test_code  {

		# get multirow from SOAP DB
		aa_log "Creating multirow."
		soap_db::db_multirow -dbn udb -extend {extra} mrs get_carrs "select carrera, pensum from caalumcarrstb where carnet = '$carnet'" {
		    set extra "$carrera||$pensum"
		}

		# review multirow values
		aa_true "Multirow rowcount matches." [expr [template::multirow size mrs]==[template::multirow size mrd]]
		aa_true "Multirow columns matches." [string eq [template::multirow columns mrs] [template::multirow columns mrd]]

		if {[template::multirow size mrs]} {
		    set row 1
		    template::multirow foreach mrs {
			aa_true "Carrera $carrera matches" [string eq $carrera [template::multirow get mrd $row carrera]]
			aa_true "Pensum $pensum matches" [string eq $pensum [template::multirow get mrd $row pensum]]
			aa_true "Extended $extra matches" [string eq $extra [template::multirow get mrd $row extra]]
			incr row
		    }
		} else {
		    aa_log "Multirow is empty."
		}

            }
    }


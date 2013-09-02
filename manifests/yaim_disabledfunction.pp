#overrides the yaim function with the same name as the resource with a function that does nothing 
define creamce::yaim_disabledfunction( 
    $function_name=$name,
    $yaim_local_functions_dir="/opt/glite/yaim/functions/local"
    )
{
  notice("disable $function_name")
    #Create empty functions with names xx, xx_setenv, xx_check
    file { "${yaim_local_functions_dir}/${function_name}":
      ensure=> present,
      content => template('creamce/yaim_disabledfunction.erb'),
      purge  => true,
    }
}

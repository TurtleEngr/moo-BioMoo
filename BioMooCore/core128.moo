$Header: /repo/public.cvs/app/BioGate/BioMooCore/core128.moo,v 1.1 2021/07/27 06:44:28 bruce Exp $

>@dump #128 with create
@create $http_port named Main Cookie-Athenticated HTTP Port:Main Cookie-Athenticated HTTP Port,port
;;#128.("listening") = 1
;;#128.("timeout_msg") = E_NONE
;;#128.("recycle_msg") = E_NONE
;;#128.("boot_msg") = E_NONE
;;#128.("redirect_from_msg") = E_NONE
;;#128.("redirect_to_msg") = E_NONE
;;#128.("create_msg") = E_NONE
;;#128.("connect_msg") = E_NONE
;;#128.("server_options") = #128
;;#128.("aliases") = {"Main Cookie-Athenticated HTTP Port", "port"}
;;#128.("description") = {"  This object uses multiple port listen to check for HTTP/1.x", "connections. It accepts them, passes the accepted data to", "$http_handler:handle_http10, and returns the resulting information.", "Settings for this.authentication_method are one of:", "  webpass, web-authentication, cookies"}
;;#128.("object_size") = {723, 1577149628}

"***finished***

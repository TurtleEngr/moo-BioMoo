$Header: /repo/public.cvs/app/BioGate/BioMooCore/core129.moo,v 1.1 2021/07/27 06:44:28 bruce Exp $

>@dump #129 with create
@create $http_port named Main Athenticated HTTP Port:Main Athenticated HTTP Port,port
;;#129.("handles_port") = 8001
;;#129.("listening") = 1
;;#129.("timeout_msg") = E_NONE
;;#129.("recycle_msg") = E_NONE
;;#129.("boot_msg") = E_NONE
;;#129.("redirect_from_msg") = E_NONE
;;#129.("redirect_to_msg") = E_NONE
;;#129.("create_msg") = E_NONE
;;#129.("connect_msg") = E_NONE
;;#129.("server_options") = #129
;;#129.("authentication_method") = "web-authentication"
;;#129.("aliases") = {"Main Athenticated HTTP Port", "port"}
;;#129.("description") = {"  This object uses multiple port listen to check for HTTP/1.x", "connections. It accepts them, passes the accepted data to", "$http_handler:handle_http10, and returns the resulting information.", "Settings for this.authentication_method are one of:", "  webpass, web-authentication, cookies"}
;;#129.("object_size") = {720, 1577149628}

"***finished***

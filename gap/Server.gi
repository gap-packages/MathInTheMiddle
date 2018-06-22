

MitM_QueueLength := 5;


InstallGlobalFunction(MitM_InterpretJson,
function(json)
end);

InstallGlobalFunction(MitM_JsonHandler,
function(addr, stream)
    local res;

    # Protocol handshake
    GapToJsonStream(stream, rec( service_name := "GAP"
                               , service_version := GAPInfo.Version
                               , service_id := ""
                               , versions := [ "1.0", "1.1", "1.2", "1.3" ] ) );
    # Flush...
    WriteLine(stream, "");
    res := JsonStreamToGap(stream);
    if not (IsBound(res.version) and
            res.version in [ "1.0", "1.1", "1.2", "1.3" ]) then
        ErrorNoReturn("Protocol error: version needs to be bound");
    fi;

    # Handle until done
    while not IsClosedStream(stream) do
        PrintTo("*errout*", "jsonhandler 1");
        res := JsonStreamToGap(stream);
        Info(InfoMitMJsonHandler, 5, "received: ", res);
        MitM_InterpretJson(res);
    od;
    return true;
end);

InstallGlobalFunction(MitM_MakeBindAddr,
function(addr)
    local res;

    res := IO_gethostbyname(addr);
    return res;
end);

MitM_AddrToString := function(addr)
    return JoinStringsWithSeparator(List(addr{[5..8]}, x -> String(INT_CHAR(x))), ".");
end;

# TODO: IPv4 only (bleh)
InstallGlobalFunction(MitM_StartServer_TCP,
function(addr, port, handlerCallback)
    local socket, client, desc, stream, res, bindaddr, listenname;

    res := IO_gethostbyname(addr);
    if res = fail then
        ErrorNoReturn("Failed to lookup address: ", LastSystemError());
        return fail;
    fi;
    bindaddr := res.addr[1];
    listenname := res.name;

    if not IsPosInt(port) or (port > 65536) then
        ErrorNoReturn("Usage: port has to be a positive integer");
        return fail;
    fi;

    # Create TCP socket
    Info(InfoMitMTCPHandler, 5, "MitM server listening for connections...");
    socket := IO_socket( IO.PF_INET, IO.SOCK_STREAM, "tcp" );
    if socket = fail then
        ErrorNoReturn("Failed to open socket: ", LastSystemError());
        return fail;
    fi;

    res := IO_bind(socket, IO_make_sockaddr_in(bindaddr, port));
    if res = fail then
        ErrorNoReturn("Failed to bind: ", LastSystemError());
        return fail;
    fi;

    Info(InfoMitMTCPHandler, 5, "MitM server listening on ", listenname, " ", port);
    IO_listen(socket, MitM_QueueLength);
    while true do
        # Currently we accept connections from anyone.
        addr := IO_MakeIPAddressPort( "0.0.0.0", 0 );

        # Accept connection, and open stream.
        client := IO_accept(socket, addr);

        # TODO: prettier
        Info(InfoMitMTCPHandler, 5, "Accepted connection from: ",
             MitM_AddrToString(addr));
        stream := InputOutputTCPStream(client);

        # Handle connection
        handlerCallback(addr, stream);

        CloseStream(stream);
        IO_close(client);
    od;
end);

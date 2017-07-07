-module(ws_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, Opts) ->
    {cowboy_websocket, Req, Opts}.

websocket_init(State) ->
    io:fwrite("hello, ~p~n", [self()]),
    gproc:mreg(p, l, [{bot, true}]),
    {ok, State}.

websocket_handle({ping, Msg}, State) ->
    {reply, {pong, Msg}, State};
websocket_handle({text, Msg}, State) ->
    {reply, {text, << "That's what she said! ", Msg/binary >>}, State};
websocket_handle(_Data, State) ->
    {ok, State}.

websocket_info({timeout, _Ref, Msg}, State) ->
    erlang:start_timer(1000, self(), <<"How' you doin'?">>),
    {reply, {text, Msg}, State};
websocket_info({msg, Msg}, State) ->
    io:fwrite("got, ~p~n", [Msg]),
    {reply, {text, Msg}, State};
websocket_info({ping, Msg}, State) ->
    {reply, {text, Msg}, State}.

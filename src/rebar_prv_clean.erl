%% -*- erlang-indent-level: 4;indent-tabs-mode: nil -*-
%% ex: ts=4 sw=4 et

-module(rebar_prv_clean).

-behaviour(rebar_provider).

-export([init/1,
         do/1]).

-include("rebar.hrl").

-define(PROVIDER, clean).
-define(DEPS, [app_discovery]).

%% ===================================================================
%% Public API
%% ===================================================================

-spec init(rebar_state:t()) -> {ok, rebar_state:t()}.
init(State) ->
    State1 = rebar_state:add_provider(State, #provider{name = ?PROVIDER,
                                                       provider_impl = ?MODULE,
                                                       bare = false,
                                                       deps = ?DEPS,
                                                       example = "rebar clean",
                                                       short_desc = "Remove compiled beam files from apps.",
                                                       desc = "",
                                                       opts = []}),
    {ok, State1}.

-spec do(rebar_state:t()) -> {ok, rebar_state:t()} | {error, string()}.
do(State) ->
    ProjectApps = rebar_state:project_apps(State),
    lists:foreach(fun(AppInfo) ->
                          ?INFO("Cleaning out ~s...~n", [rebar_app_info:name(AppInfo)]),
                          rebar_erlc_compiler:clean(State, ec_cnv:to_list(rebar_app_info:dir(AppInfo)))
                  end, ProjectApps),
    {ok, State}.

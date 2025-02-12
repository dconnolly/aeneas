module T = Types
module PV = PrimitiveValues
module V = Values
module LA = LlbcAst
module E = Expressions
module C = Contexts
module Subst = Substitute
module L = Logging
module Inv = Invariants
module S = SynthesizeSymbolic
open Cps
open InterpreterPaths

(** Read a place (CPS-style function).

    We also check that the value *doesn't contain bottoms or reserved
    borrows*.

    This function doesn't reorganize the context to make sure we can read
    the place. If needs be, you should call {!InterpreterPaths.update_ctx_along_read_place} first.
 *)
val read_place : access_kind -> E.place -> (V.typed_value -> m_fun) -> m_fun

(** Auxiliary function.

    Prepare the access to a place in a right-value (typically an operand) by
    reorganizing the environment.

    We reorganize the environment so that:
    - we can access the place (we prepare *along* the path)
    - the value at the place itself doesn't contain loans (the [access_kind]
      controls whether we only end mutable loans, or also shared loans).

    We also check, after the reorganization, that the value at the place
    *doesn't contain any bottom nor reserved borrows*.

    [expand_prim_copy]: if [true], expand the symbolic values which are
    primitively copyable and contain borrows.
 *)
val access_rplace_reorganize_and_read :
  C.config ->
  bool ->
  access_kind ->
  E.place ->
  (V.typed_value -> m_fun) ->
  m_fun

(** Evaluate an operand.

    Reorganize the context, then evaluate the operand.

    **Warning**: this function shouldn't be used to evaluate a list of
    operands (for a function call, for instance): we must do *one* reorganization
    of the environment, before evaluating all the operands at once.
    Use {!eval_operands} instead.
 *)
val eval_operand : C.config -> E.operand -> (V.typed_value -> m_fun) -> m_fun

(** Evaluate several operands at once. *)
val eval_operands :
  C.config -> E.operand list -> (V.typed_value list -> m_fun) -> m_fun

(** Evaluate an rvalue which is not a global (globals are handled elsewhere).

    Transmits the computed rvalue to the received continuation.

    Note that this function fails on {!constructor:Aeneas.Expressions.rvalue.Discriminant}: discriminant
    reads should have been eliminated from the AST.
 *)
val eval_rvalue_not_global :
  C.config -> E.rvalue -> ((V.typed_value, eval_error) result -> m_fun) -> m_fun

(** Evaluate a fake read (update the context so that we can read a place) *)
val eval_fake_read : C.config -> E.place -> cm_fun

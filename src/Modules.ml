open Types
open CfimAst

type 'id g_declaration_group = NonRec of 'id | Rec of 'id list
[@@deriving show]

type type_declaration_group = TypeDefId.id g_declaration_group [@@deriving show]

type fun_declaration_group = FunDefId.id g_declaration_group [@@deriving show]

(** Module declaration *)
type declaration_group =
  | Type of type_declaration_group
  | Fun of fun_declaration_group
[@@deriving show]

type cfim_module = {
  name : string;
  declarations : declaration_group list;
  types : type_def list;
  functions : fun_def list;
}
(** CFIM module *)

let compute_defs_maps (m : cfim_module) :
    type_def TypeDefId.Map.t * fun_def FunDefId.Map.t =
  let types_map =
    List.fold_left
      (fun m (def : type_def) -> TypeDefId.Map.add def.def_id def m)
      TypeDefId.Map.empty m.types
  in
  let funs_map =
    List.fold_left
      (fun m (def : fun_def) -> FunDefId.Map.add def.def_id def m)
      FunDefId.Map.empty m.functions
  in
  (types_map, funs_map)

(** Split a module's declarations between types and functions *)
let split_declarations (decls : declaration_group list) :
    type_declaration_group list * fun_declaration_group list =
  let rec split decls =
    match decls with
    | [] -> ([], [])
    | d :: decls' -> (
        let types, funs = split decls' in
        match d with
        | Type decl -> (decl :: types, funs)
        | Fun decl -> (types, decl :: funs))
  in
  split decls

(** Split a module's declarations into two maps from type/fun ids to
    declaration groups.
 *)
let split_declarations_to_group_maps (decls : declaration_group list) :
    type_declaration_group TypeDefId.Map.t
    * fun_declaration_group FunDefId.Map.t =
  let module G (M : Map.S) = struct
    let add_group (map : M.key g_declaration_group M.t)
        (group : M.key g_declaration_group) : M.key g_declaration_group M.t =
      match group with
      | NonRec id -> M.add id group map
      | Rec ids -> List.fold_left (fun map id -> M.add id group map) map ids

    let create_map (groups : M.key g_declaration_group list) :
        M.key g_declaration_group M.t =
      List.fold_left add_group M.empty groups
  end in
  let types, funs = split_declarations decls in
  let module TG = G (TypeDefId.Map) in
  let types = TG.create_map types in
  let module FG = G (FunDefId.Map) in
  let funs = FG.create_map funs in
  (types, funs)

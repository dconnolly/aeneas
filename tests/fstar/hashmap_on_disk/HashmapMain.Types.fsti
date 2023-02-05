(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [hashmap_main]: type definitions *)
module HashmapMain.Types
open Primitives

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [hashmap_main::hashmap::List] *)
type hashmap_list_t (t : Type0) =
| HashmapListCons : usize -> t -> hashmap_list_t t -> hashmap_list_t t
| HashmapListNil : hashmap_list_t t

(** [hashmap_main::hashmap::HashMap] *)
type hashmap_hash_map_t (t : Type0) =
{
  hashmap_hash_map_num_entries : usize;
  hashmap_hash_map_max_load_factor : (usize & usize);
  hashmap_hash_map_max_load : usize;
  hashmap_hash_map_slots : vec (hashmap_list_t t);
}

(** The state type used in the state-error monad *)
val state : Type0


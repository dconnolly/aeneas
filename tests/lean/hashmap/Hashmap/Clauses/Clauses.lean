-- [hashmap]: the decreases clauses
import Base.Primitives
import Hashmap.Types

/- [hashmap::HashMap::{0}::allocate_slots]: termination measure -/
@[simp]
def hash_map_allocate_slots_loop_terminates (T : Type) (slots : vec (list_t T))
  (n : USize) :=
  (slots, n)

syntax "hash_map_allocate_slots_loop_decreases" term+ : tactic

macro_rules
| `(tactic| hash_map_allocate_slots_loop_decreases $slots $n) =>`(tactic| sorry)

/- [hashmap::HashMap::{0}::clear]: termination measure -/
@[simp]
def hash_map_clear_loop_terminates (T : Type) (slots : vec (list_t T))
  (i : USize) :=
  (slots, i)

syntax "hash_map_clear_loop_decreases" term+ : tactic

macro_rules
| `(tactic| hash_map_clear_loop_decreases $slots $i) =>`(tactic| sorry)

/- [hashmap::HashMap::{0}::insert_in_list]: termination measure -/
@[simp]
def hash_map_insert_in_list_loop_terminates (T : Type) (key : USize)
  (value : T) (ls : list_t T) :=
  (key, value, ls)

syntax "hash_map_insert_in_list_loop_decreases" term+ : tactic

macro_rules
| `(tactic| hash_map_insert_in_list_loop_decreases $key $value $ls) =>
  `(tactic| sorry)

/- [hashmap::HashMap::{0}::move_elements_from_list]: termination measure -/
@[simp]
def hash_map_move_elements_from_list_loop_terminates (T : Type)
  (ntable : hash_map_t T) (ls : list_t T) :=
  (ntable, ls)

syntax "hash_map_move_elements_from_list_loop_decreases" term+ : tactic

macro_rules
| `(tactic| hash_map_move_elements_from_list_loop_decreases $ntable $ls) =>
  `(tactic| sorry)

/- [hashmap::HashMap::{0}::move_elements]: termination measure -/
@[simp]
def hash_map_move_elements_loop_terminates (T : Type) (ntable : hash_map_t T)
  (slots : vec (list_t T)) (i : USize) :=
  (ntable, slots, i)

syntax "hash_map_move_elements_loop_decreases" term+ : tactic

macro_rules
| `(tactic| hash_map_move_elements_loop_decreases $ntable $slots $i) =>
  `(tactic| sorry)

/- [hashmap::HashMap::{0}::contains_key_in_list]: termination measure -/
@[simp]
def hash_map_contains_key_in_list_loop_terminates (T : Type) (key : USize)
  (ls : list_t T) :=
  (key, ls)

syntax "hash_map_contains_key_in_list_loop_decreases" term+ : tactic

macro_rules
| `(tactic| hash_map_contains_key_in_list_loop_decreases $key $ls) =>
  `(tactic| sorry)

/- [hashmap::HashMap::{0}::get_in_list]: termination measure -/
@[simp]
def hash_map_get_in_list_loop_terminates (T : Type) (key : USize)
  (ls : list_t T) :=
  (key, ls)

syntax "hash_map_get_in_list_loop_decreases" term+ : tactic

macro_rules
| `(tactic| hash_map_get_in_list_loop_decreases $key $ls) =>`(tactic| sorry)

/- [hashmap::HashMap::{0}::get_mut_in_list]: termination measure -/
@[simp]
def hash_map_get_mut_in_list_loop_terminates (T : Type) (ls : list_t T)
  (key : USize) :=
  (ls, key)

syntax "hash_map_get_mut_in_list_loop_decreases" term+ : tactic

macro_rules
| `(tactic| hash_map_get_mut_in_list_loop_decreases $ls $key) =>`(tactic| sorry)

/- [hashmap::HashMap::{0}::remove_from_list]: termination measure -/
@[simp]
def hash_map_remove_from_list_loop_terminates (T : Type) (key : USize)
  (ls : list_t T) :=
  (key, ls)

syntax "hash_map_remove_from_list_loop_decreases" term+ : tactic

macro_rules
| `(tactic| hash_map_remove_from_list_loop_decreases $key $ls) =>`(tactic| sorry)


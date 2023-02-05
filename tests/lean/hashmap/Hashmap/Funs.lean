-- THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS
-- [hashmap]: function definitions
import Base.Primitives
import Hashmap.Types
import Hashmap.Clauses.Clauses

/- [hashmap::hash_key] -/
def hash_key_fwd (k : USize) : result USize := result.ret k

/- [hashmap::HashMap::{0}::allocate_slots] -/
def hash_map_allocate_slots_loop_fwd
  (T : Type) (slots : vec (list_t T)) (n : USize) :
  (result (vec (list_t T)))
  :=
  if n > (USize.ofNatCore 0 (by intlit))
  then
    do
      let slots0 <- vec_push_back (list_t T) slots list_t.ListNil
      let n0 <- USize.checked_sub n (USize.ofNatCore 1 (by intlit))
      hash_map_allocate_slots_loop_fwd T slots0 n0
  else result.ret slots
termination_by hash_map_allocate_slots_loop_fwd slots n =>
  hash_map_allocate_slots_loop_terminates T slots n
decreasing_by hash_map_allocate_slots_loop_decreases slots n

/- [hashmap::HashMap::{0}::allocate_slots] -/
def hash_map_allocate_slots_fwd
  (T : Type) (slots : vec (list_t T)) (n : USize) : result (vec (list_t T)) :=
  hash_map_allocate_slots_loop_fwd T slots n

/- [hashmap::HashMap::{0}::new_with_capacity] -/
def hash_map_new_with_capacity_fwd
  (T : Type) (capacity : USize) (max_load_dividend : USize)
  (max_load_divisor : USize) :
  result (hash_map_t T)
  :=
  do
    let v := vec_new (list_t T)
    let slots <- hash_map_allocate_slots_fwd T v capacity
    let i <- USize.checked_mul capacity max_load_dividend
    let i0 <- USize.checked_div i max_load_divisor
    result.ret
      {
        hash_map_num_entries := (USize.ofNatCore 0 (by intlit)),
        hash_map_max_load_factor := (max_load_dividend, max_load_divisor),
        hash_map_max_load := i0,
        hash_map_slots := slots
      }

/- [hashmap::HashMap::{0}::new] -/
def hash_map_new_fwd (T : Type) : result (hash_map_t T) :=
  hash_map_new_with_capacity_fwd T (USize.ofNatCore 32 (by intlit))
    (USize.ofNatCore 4 (by intlit)) (USize.ofNatCore 5 (by intlit))

/- [hashmap::HashMap::{0}::clear] -/
def hash_map_clear_loop_fwd_back
  (T : Type) (slots : vec (list_t T)) (i : USize) :
  (result (vec (list_t T)))
  :=
  let i0 := vec_len (list_t T) slots
  if i < i0
  then
    do
      let i1 <- USize.checked_add i (USize.ofNatCore 1 (by intlit))
      let slots0 <- vec_index_mut_back (list_t T) slots i list_t.ListNil
      hash_map_clear_loop_fwd_back T slots0 i1
  else result.ret slots
termination_by hash_map_clear_loop_fwd_back slots i =>
  hash_map_clear_loop_terminates T slots i
decreasing_by hash_map_clear_loop_decreases slots i

/- [hashmap::HashMap::{0}::clear] -/
def hash_map_clear_fwd_back
  (T : Type) (self : hash_map_t T) : result (hash_map_t T) :=
  do
    let v <-
      hash_map_clear_loop_fwd_back T self.hash_map_slots
        (USize.ofNatCore 0 (by intlit))
    result.ret
      {
        hash_map_num_entries := (USize.ofNatCore 0 (by intlit)),
        hash_map_max_load_factor := self.hash_map_max_load_factor,
        hash_map_max_load := self.hash_map_max_load,
        hash_map_slots := v
      }

/- [hashmap::HashMap::{0}::len] -/
def hash_map_len_fwd (T : Type) (self : hash_map_t T) : result USize :=
  result.ret self.hash_map_num_entries

/- [hashmap::HashMap::{0}::insert_in_list] -/
def hash_map_insert_in_list_loop_fwd
  (T : Type) (key : USize) (value : T) (ls : list_t T) : (result Bool) :=
  match ls with
  | list_t.ListCons ckey cvalue tl =>
    if ckey = key
    then result.ret false
    else hash_map_insert_in_list_loop_fwd T key value tl
  | list_t.ListNil => result.ret true
  
termination_by hash_map_insert_in_list_loop_fwd key value ls =>
  hash_map_insert_in_list_loop_terminates T key value ls
decreasing_by hash_map_insert_in_list_loop_decreases key value ls

/- [hashmap::HashMap::{0}::insert_in_list] -/
def hash_map_insert_in_list_fwd
  (T : Type) (key : USize) (value : T) (ls : list_t T) : result Bool :=
  hash_map_insert_in_list_loop_fwd T key value ls

/- [hashmap::HashMap::{0}::insert_in_list] -/
def hash_map_insert_in_list_loop_back
  (T : Type) (key : USize) (value : T) (ls : list_t T) : (result (list_t T)) :=
  match ls with
  | list_t.ListCons ckey cvalue tl =>
    if ckey = key
    then result.ret (list_t.ListCons ckey value tl)
    else
      do
        let tl0 <- hash_map_insert_in_list_loop_back T key value tl
        result.ret (list_t.ListCons ckey cvalue tl0)
  | list_t.ListNil =>
    let l := list_t.ListNil result.ret (list_t.ListCons key value l)
  
termination_by hash_map_insert_in_list_loop_back key value ls =>
  hash_map_insert_in_list_loop_terminates T key value ls
decreasing_by hash_map_insert_in_list_loop_decreases key value ls

/- [hashmap::HashMap::{0}::insert_in_list] -/
def hash_map_insert_in_list_back
  (T : Type) (key : USize) (value : T) (ls : list_t T) : result (list_t T) :=
  hash_map_insert_in_list_loop_back T key value ls

/- [hashmap::HashMap::{0}::insert_no_resize] -/
def hash_map_insert_no_resize_fwd_back
  (T : Type) (self : hash_map_t T) (key : USize) (value : T) :
  result (hash_map_t T)
  :=
  do
    let hash <- hash_key_fwd key
    let i := vec_len (list_t T) self.hash_map_slots
    let hash_mod <- USize.checked_rem hash i
    let l <- vec_index_mut_fwd (list_t T) self.hash_map_slots hash_mod
    let inserted <- hash_map_insert_in_list_fwd T key value l
    if inserted
    then
      do
        let i0 <- USize.checked_add self.hash_map_num_entries
          (USize.ofNatCore 1 (by intlit))
        let l0 <- hash_map_insert_in_list_back T key value l
        let v <- vec_index_mut_back (list_t T) self.hash_map_slots hash_mod l0
        result.ret
          {
            hash_map_num_entries := i0,
            hash_map_max_load_factor := self.hash_map_max_load_factor,
            hash_map_max_load := self.hash_map_max_load,
            hash_map_slots := v
          }
    else
      do
        let l0 <- hash_map_insert_in_list_back T key value l
        let v <- vec_index_mut_back (list_t T) self.hash_map_slots hash_mod l0
        result.ret
          {
            hash_map_num_entries := self.hash_map_num_entries,
            hash_map_max_load_factor := self.hash_map_max_load_factor,
            hash_map_max_load := self.hash_map_max_load,
            hash_map_slots := v
          }

/- [core::num::u32::{9}::MAX] -/
def core_num_u32_max_body : result UInt32 :=
  result.ret (UInt32.ofNatCore 4294967295 (by intlit))
def core_num_u32_max_c : UInt32 := eval_global core_num_u32_max_body (by simp)

/- [hashmap::HashMap::{0}::move_elements_from_list] -/
def hash_map_move_elements_from_list_loop_fwd_back
  (T : Type) (ntable : hash_map_t T) (ls : list_t T) :
  (result (hash_map_t T))
  :=
  match ls with
  | list_t.ListCons k v tl =>
    do
      let ntable0 <- hash_map_insert_no_resize_fwd_back T ntable k v
      hash_map_move_elements_from_list_loop_fwd_back T ntable0 tl
  | list_t.ListNil => result.ret ntable
  
termination_by hash_map_move_elements_from_list_loop_fwd_back ntable ls =>
  hash_map_move_elements_from_list_loop_terminates T ntable ls
decreasing_by hash_map_move_elements_from_list_loop_decreases ntable ls

/- [hashmap::HashMap::{0}::move_elements_from_list] -/
def hash_map_move_elements_from_list_fwd_back
  (T : Type) (ntable : hash_map_t T) (ls : list_t T) : result (hash_map_t T) :=
  hash_map_move_elements_from_list_loop_fwd_back T ntable ls

/- [hashmap::HashMap::{0}::move_elements] -/
def hash_map_move_elements_loop_fwd_back
  (T : Type) (ntable : hash_map_t T) (slots : vec (list_t T)) (i : USize) :
  (result ((hash_map_t T) × (vec (list_t T))))
  :=
  let i0 := vec_len (list_t T) slots
  if i < i0
  then
    do
      let l <- vec_index_mut_fwd (list_t T) slots i
      let ls := mem_replace_fwd (list_t T) l list_t.ListNil
      let ntable0 <- hash_map_move_elements_from_list_fwd_back T ntable ls
      let i1 <- USize.checked_add i (USize.ofNatCore 1 (by intlit))
      let l0 := mem_replace_back (list_t T) l list_t.ListNil
      let slots0 <- vec_index_mut_back (list_t T) slots i l0
      hash_map_move_elements_loop_fwd_back T ntable0 slots0 i1
  else result.ret (ntable, slots)
termination_by hash_map_move_elements_loop_fwd_back ntable slots i =>
  hash_map_move_elements_loop_terminates T ntable slots i
decreasing_by hash_map_move_elements_loop_decreases ntable slots i

/- [hashmap::HashMap::{0}::move_elements] -/
def hash_map_move_elements_fwd_back
  (T : Type) (ntable : hash_map_t T) (slots : vec (list_t T)) (i : USize) :
  result ((hash_map_t T) × (vec (list_t T)))
  :=
  hash_map_move_elements_loop_fwd_back T ntable slots i

/- [hashmap::HashMap::{0}::try_resize] -/
def hash_map_try_resize_fwd_back
  (T : Type) (self : hash_map_t T) : result (hash_map_t T) :=
  do
    let max_usize <- scalar_cast USize core_num_u32_max_c
    let capacity := vec_len (list_t T) self.hash_map_slots
    let n1 <- USize.checked_div max_usize (USize.ofNatCore 2 (by intlit))
    let (i, i0) := self.hash_map_max_load_factor
    let i1 <- USize.checked_div n1 i
    if capacity <= i1
    then
      do
        let i2 <- USize.checked_mul capacity (USize.ofNatCore 2 (by intlit))
        let ntable <- hash_map_new_with_capacity_fwd T i2 i i0
        let (ntable0, _) <-
          hash_map_move_elements_fwd_back T ntable self.hash_map_slots
            (USize.ofNatCore 0 (by intlit))
        result.ret
          {
            hash_map_num_entries := self.hash_map_num_entries,
            hash_map_max_load_factor := (i, i0),
            hash_map_max_load := ntable0.hash_map_max_load,
            hash_map_slots := ntable0.hash_map_slots
          }
    else
      result.ret
        {
          hash_map_num_entries := self.hash_map_num_entries,
          hash_map_max_load_factor := (i, i0),
          hash_map_max_load := self.hash_map_max_load,
          hash_map_slots := self.hash_map_slots
        }

/- [hashmap::HashMap::{0}::insert] -/
def hash_map_insert_fwd_back
  (T : Type) (self : hash_map_t T) (key : USize) (value : T) :
  result (hash_map_t T)
  :=
  do
    let self0 <- hash_map_insert_no_resize_fwd_back T self key value
    let i <- hash_map_len_fwd T self0
    if i > self0.hash_map_max_load
    then hash_map_try_resize_fwd_back T self0
    else result.ret self0

/- [hashmap::HashMap::{0}::contains_key_in_list] -/
def hash_map_contains_key_in_list_loop_fwd
  (T : Type) (key : USize) (ls : list_t T) : (result Bool) :=
  match ls with
  | list_t.ListCons ckey t tl =>
    if ckey = key
    then result.ret true
    else hash_map_contains_key_in_list_loop_fwd T key tl
  | list_t.ListNil => result.ret false
  
termination_by hash_map_contains_key_in_list_loop_fwd key ls =>
  hash_map_contains_key_in_list_loop_terminates T key ls
decreasing_by hash_map_contains_key_in_list_loop_decreases key ls

/- [hashmap::HashMap::{0}::contains_key_in_list] -/
def hash_map_contains_key_in_list_fwd
  (T : Type) (key : USize) (ls : list_t T) : result Bool :=
  hash_map_contains_key_in_list_loop_fwd T key ls

/- [hashmap::HashMap::{0}::contains_key] -/
def hash_map_contains_key_fwd
  (T : Type) (self : hash_map_t T) (key : USize) : result Bool :=
  do
    let hash <- hash_key_fwd key
    let i := vec_len (list_t T) self.hash_map_slots
    let hash_mod <- USize.checked_rem hash i
    let l <- vec_index_fwd (list_t T) self.hash_map_slots hash_mod
    hash_map_contains_key_in_list_fwd T key l

/- [hashmap::HashMap::{0}::get_in_list] -/
def hash_map_get_in_list_loop_fwd
  (T : Type) (key : USize) (ls : list_t T) : (result T) :=
  match ls with
  | list_t.ListCons ckey cvalue tl =>
    if ckey = key
    then result.ret cvalue
    else hash_map_get_in_list_loop_fwd T key tl
  | list_t.ListNil => result.fail error.panic
  
termination_by hash_map_get_in_list_loop_fwd key ls =>
  hash_map_get_in_list_loop_terminates T key ls
decreasing_by hash_map_get_in_list_loop_decreases key ls

/- [hashmap::HashMap::{0}::get_in_list] -/
def hash_map_get_in_list_fwd
  (T : Type) (key : USize) (ls : list_t T) : result T :=
  hash_map_get_in_list_loop_fwd T key ls

/- [hashmap::HashMap::{0}::get] -/
def hash_map_get_fwd
  (T : Type) (self : hash_map_t T) (key : USize) : result T :=
  do
    let hash <- hash_key_fwd key
    let i := vec_len (list_t T) self.hash_map_slots
    let hash_mod <- USize.checked_rem hash i
    let l <- vec_index_fwd (list_t T) self.hash_map_slots hash_mod
    hash_map_get_in_list_fwd T key l

/- [hashmap::HashMap::{0}::get_mut_in_list] -/
def hash_map_get_mut_in_list_loop_fwd
  (T : Type) (ls : list_t T) (key : USize) : (result T) :=
  match ls with
  | list_t.ListCons ckey cvalue tl =>
    if ckey = key
    then result.ret cvalue
    else hash_map_get_mut_in_list_loop_fwd T tl key
  | list_t.ListNil => result.fail error.panic
  
termination_by hash_map_get_mut_in_list_loop_fwd ls key =>
  hash_map_get_mut_in_list_loop_terminates T ls key
decreasing_by hash_map_get_mut_in_list_loop_decreases ls key

/- [hashmap::HashMap::{0}::get_mut_in_list] -/
def hash_map_get_mut_in_list_fwd
  (T : Type) (ls : list_t T) (key : USize) : result T :=
  hash_map_get_mut_in_list_loop_fwd T ls key

/- [hashmap::HashMap::{0}::get_mut_in_list] -/
def hash_map_get_mut_in_list_loop_back
  (T : Type) (ls : list_t T) (key : USize) (ret0 : T) : (result (list_t T)) :=
  match ls with
  | list_t.ListCons ckey cvalue tl =>
    if ckey = key
    then result.ret (list_t.ListCons ckey ret0 tl)
    else
      do
        let tl0 <- hash_map_get_mut_in_list_loop_back T tl key ret0
        result.ret (list_t.ListCons ckey cvalue tl0)
  | list_t.ListNil => result.fail error.panic
  
termination_by hash_map_get_mut_in_list_loop_back ls key ret0 =>
  hash_map_get_mut_in_list_loop_terminates T ls key
decreasing_by hash_map_get_mut_in_list_loop_decreases ls key

/- [hashmap::HashMap::{0}::get_mut_in_list] -/
def hash_map_get_mut_in_list_back
  (T : Type) (ls : list_t T) (key : USize) (ret0 : T) : result (list_t T) :=
  hash_map_get_mut_in_list_loop_back T ls key ret0

/- [hashmap::HashMap::{0}::get_mut] -/
def hash_map_get_mut_fwd
  (T : Type) (self : hash_map_t T) (key : USize) : result T :=
  do
    let hash <- hash_key_fwd key
    let i := vec_len (list_t T) self.hash_map_slots
    let hash_mod <- USize.checked_rem hash i
    let l <- vec_index_mut_fwd (list_t T) self.hash_map_slots hash_mod
    hash_map_get_mut_in_list_fwd T l key

/- [hashmap::HashMap::{0}::get_mut] -/
def hash_map_get_mut_back
  (T : Type) (self : hash_map_t T) (key : USize) (ret0 : T) :
  result (hash_map_t T)
  :=
  do
    let hash <- hash_key_fwd key
    let i := vec_len (list_t T) self.hash_map_slots
    let hash_mod <- USize.checked_rem hash i
    let l <- vec_index_mut_fwd (list_t T) self.hash_map_slots hash_mod
    let l0 <- hash_map_get_mut_in_list_back T l key ret0
    let v <- vec_index_mut_back (list_t T) self.hash_map_slots hash_mod l0
    result.ret
      {
        hash_map_num_entries := self.hash_map_num_entries,
        hash_map_max_load_factor := self.hash_map_max_load_factor,
        hash_map_max_load := self.hash_map_max_load,
        hash_map_slots := v
      }

/- [hashmap::HashMap::{0}::remove_from_list] -/
def hash_map_remove_from_list_loop_fwd
  (T : Type) (key : USize) (ls : list_t T) : (result (Option T)) :=
  match ls with
  | list_t.ListCons ckey t tl =>
    if ckey = key
    then
      let mv_ls :=
        mem_replace_fwd (list_t T) (list_t.ListCons ckey t tl) list_t.ListNil
      match mv_ls with
      | list_t.ListCons i cvalue tl0 => result.ret (Option.some cvalue)
      | list_t.ListNil => result.fail error.panic
      
    else hash_map_remove_from_list_loop_fwd T key tl
  | list_t.ListNil => result.ret Option.none
  
termination_by hash_map_remove_from_list_loop_fwd key ls =>
  hash_map_remove_from_list_loop_terminates T key ls
decreasing_by hash_map_remove_from_list_loop_decreases key ls

/- [hashmap::HashMap::{0}::remove_from_list] -/
def hash_map_remove_from_list_fwd
  (T : Type) (key : USize) (ls : list_t T) : result (Option T) :=
  hash_map_remove_from_list_loop_fwd T key ls

/- [hashmap::HashMap::{0}::remove_from_list] -/
def hash_map_remove_from_list_loop_back
  (T : Type) (key : USize) (ls : list_t T) : (result (list_t T)) :=
  match ls with
  | list_t.ListCons ckey t tl =>
    if ckey = key
    then
      let mv_ls :=
        mem_replace_fwd (list_t T) (list_t.ListCons ckey t tl) list_t.ListNil
      match mv_ls with
      | list_t.ListCons i cvalue tl0 => result.ret tl0
      | list_t.ListNil => result.fail error.panic
      
    else
      do
        let tl0 <- hash_map_remove_from_list_loop_back T key tl
        result.ret (list_t.ListCons ckey t tl0)
  | list_t.ListNil => result.ret list_t.ListNil
  
termination_by hash_map_remove_from_list_loop_back key ls =>
  hash_map_remove_from_list_loop_terminates T key ls
decreasing_by hash_map_remove_from_list_loop_decreases key ls

/- [hashmap::HashMap::{0}::remove_from_list] -/
def hash_map_remove_from_list_back
  (T : Type) (key : USize) (ls : list_t T) : result (list_t T) :=
  hash_map_remove_from_list_loop_back T key ls

/- [hashmap::HashMap::{0}::remove] -/
def hash_map_remove_fwd
  (T : Type) (self : hash_map_t T) (key : USize) : result (Option T) :=
  do
    let hash <- hash_key_fwd key
    let i := vec_len (list_t T) self.hash_map_slots
    let hash_mod <- USize.checked_rem hash i
    let l <- vec_index_mut_fwd (list_t T) self.hash_map_slots hash_mod
    let x <- hash_map_remove_from_list_fwd T key l
    match x with
    | Option.none => result.ret Option.none
    | Option.some x0 =>
      do
        let _ <- USize.checked_sub self.hash_map_num_entries
          (USize.ofNatCore 1 (by intlit))
        result.ret (Option.some x0)
    

/- [hashmap::HashMap::{0}::remove] -/
def hash_map_remove_back
  (T : Type) (self : hash_map_t T) (key : USize) : result (hash_map_t T) :=
  do
    let hash <- hash_key_fwd key
    let i := vec_len (list_t T) self.hash_map_slots
    let hash_mod <- USize.checked_rem hash i
    let l <- vec_index_mut_fwd (list_t T) self.hash_map_slots hash_mod
    let x <- hash_map_remove_from_list_fwd T key l
    match x with
    | Option.none =>
      do
        let l0 <- hash_map_remove_from_list_back T key l
        let v <- vec_index_mut_back (list_t T) self.hash_map_slots hash_mod l0
        result.ret
          {
            hash_map_num_entries := self.hash_map_num_entries,
            hash_map_max_load_factor := self.hash_map_max_load_factor,
            hash_map_max_load := self.hash_map_max_load,
            hash_map_slots := v
          }
    | Option.some x0 =>
      do
        let i0 <- USize.checked_sub self.hash_map_num_entries
          (USize.ofNatCore 1 (by intlit))
        let l0 <- hash_map_remove_from_list_back T key l
        let v <- vec_index_mut_back (list_t T) self.hash_map_slots hash_mod l0
        result.ret
          {
            hash_map_num_entries := i0,
            hash_map_max_load_factor := self.hash_map_max_load_factor,
            hash_map_max_load := self.hash_map_max_load,
            hash_map_slots := v
          }
    

/- [hashmap::test1] -/
def test1_fwd : result Unit :=
  do
    let hm <- hash_map_new_fwd UInt64
    let hm0 <-
      hash_map_insert_fwd_back UInt64 hm (USize.ofNatCore 0 (by intlit))
        (UInt64.ofNatCore 42 (by intlit))
    let hm1 <-
      hash_map_insert_fwd_back UInt64 hm0 (USize.ofNatCore 128 (by intlit))
        (UInt64.ofNatCore 18 (by intlit))
    let hm2 <-
      hash_map_insert_fwd_back UInt64 hm1 (USize.ofNatCore 1024 (by intlit))
        (UInt64.ofNatCore 138 (by intlit))
    let hm3 <-
      hash_map_insert_fwd_back UInt64 hm2 (USize.ofNatCore 1056 (by intlit))
        (UInt64.ofNatCore 256 (by intlit))
    let i <- hash_map_get_fwd UInt64 hm3 (USize.ofNatCore 128 (by intlit))
    if not (i = (UInt64.ofNatCore 18 (by intlit)))
    then result.fail error.panic
    else
      do
        let hm4 <-
          hash_map_get_mut_back UInt64 hm3 (USize.ofNatCore 1024 (by intlit))
            (UInt64.ofNatCore 56 (by intlit))
        let i0 <-
          hash_map_get_fwd UInt64 hm4 (USize.ofNatCore 1024 (by intlit))
        if not (i0 = (UInt64.ofNatCore 56 (by intlit)))
        then result.fail error.panic
        else
          do
            let x <-
              hash_map_remove_fwd UInt64 hm4 (USize.ofNatCore 1024 (by intlit))
            match x with
            | Option.none => result.fail error.panic
            | Option.some x0 =>
              if not (x0 = (UInt64.ofNatCore 56 (by intlit)))
              then result.fail error.panic
              else
                do
                  let hm5 <-
                    hash_map_remove_back UInt64 hm4
                      (USize.ofNatCore 1024 (by intlit))
                  let i1 <-
                    hash_map_get_fwd UInt64 hm5 (USize.ofNatCore 0 (by intlit))
                  if not (i1 = (UInt64.ofNatCore 42 (by intlit)))
                  then result.fail error.panic
                  else
                    do
                      let i2 <-
                        hash_map_get_fwd UInt64 hm5
                          (USize.ofNatCore 128 (by intlit))
                      if not (i2 = (UInt64.ofNatCore 18 (by intlit)))
                      then result.fail error.panic
                      else
                        do
                          let i3 <-
                            hash_map_get_fwd UInt64 hm5
                              (USize.ofNatCore 1056 (by intlit))
                          if not (i3 = (UInt64.ofNatCore 256 (by intlit)))
                          then result.fail error.panic
                          else result.ret ()
            

/- Unit test for [hashmap::test1] -/
#assert (test1_fwd = .ret ())


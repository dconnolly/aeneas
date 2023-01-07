(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [hashmap_main]: function definitions *)
module HashmapMain.Funs
open Primitives
include HashmapMain.Types
include HashmapMain.Opaque
include HashmapMain.Clauses

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [hashmap_main::hashmap::hash_key] *)
let hashmap_hash_key_fwd (k : usize) : result usize = Return k

(** [hashmap_main::hashmap::HashMap::{0}::allocate_slots] *)
let rec hashmap_hash_map_allocate_slots_loop_fwd
  (t : Type0) (slots : vec (hashmap_list_t t)) (n : usize) :
  Tot (result (vec (hashmap_list_t t)))
  (decreases (hashmap_hash_map_allocate_slots_decreases t slots n))
  =
  if n > 0
  then
    begin match vec_push_back (hashmap_list_t t) slots HashmapListNil with
    | Fail e -> Fail e
    | Return slots0 ->
      begin match usize_sub n 1 with
      | Fail e -> Fail e
      | Return n0 -> hashmap_hash_map_allocate_slots_loop_fwd t slots0 n0
      end
    end
  else Return slots

(** [hashmap_main::hashmap::HashMap::{0}::allocate_slots] *)
let hashmap_hash_map_allocate_slots_fwd
  (t : Type0) (slots : vec (hashmap_list_t t)) (n : usize) :
  result (vec (hashmap_list_t t))
  =
  hashmap_hash_map_allocate_slots_loop_fwd t slots n

(** [hashmap_main::hashmap::HashMap::{0}::new_with_capacity] *)
let hashmap_hash_map_new_with_capacity_fwd
  (t : Type0) (capacity : usize) (max_load_dividend : usize)
  (max_load_divisor : usize) :
  result (hashmap_hash_map_t t)
  =
  let v = vec_new (hashmap_list_t t) in
  begin match hashmap_hash_map_allocate_slots_fwd t v capacity with
  | Fail e -> Fail e
  | Return slots ->
    begin match usize_mul capacity max_load_dividend with
    | Fail e -> Fail e
    | Return i ->
      begin match usize_div i max_load_divisor with
      | Fail e -> Fail e
      | Return i0 ->
        Return (Mkhashmap_hash_map_t 0 (max_load_dividend, max_load_divisor) i0
          slots)
      end
    end
  end

(** [hashmap_main::hashmap::HashMap::{0}::new] *)
let hashmap_hash_map_new_fwd (t : Type0) : result (hashmap_hash_map_t t) =
  hashmap_hash_map_new_with_capacity_fwd t 32 4 5

(** [hashmap_main::hashmap::HashMap::{0}::clear_slots] *)
let rec hashmap_hash_map_clear_slots_loop_fwd_back
  (t : Type0) (slots : vec (hashmap_list_t t)) (i : usize) :
  Tot (result (vec (hashmap_list_t t)))
  (decreases (hashmap_hash_map_clear_slots_decreases t slots i))
  =
  let i0 = vec_len (hashmap_list_t t) slots in
  if i < i0
  then
    begin match usize_add i 1 with
    | Fail e -> Fail e
    | Return i1 ->
      begin match vec_index_mut_back (hashmap_list_t t) slots i HashmapListNil
        with
      | Fail e -> Fail e
      | Return slots0 -> hashmap_hash_map_clear_slots_loop_fwd_back t slots0 i1
      end
    end
  else Return slots

(** [hashmap_main::hashmap::HashMap::{0}::clear_slots] *)
let hashmap_hash_map_clear_slots_fwd_back
  (t : Type0) (slots : vec (hashmap_list_t t)) :
  result (vec (hashmap_list_t t))
  =
  hashmap_hash_map_clear_slots_loop_fwd_back t slots 0

(** [hashmap_main::hashmap::HashMap::{0}::clear] *)
let hashmap_hash_map_clear_fwd_back
  (t : Type0) (self : hashmap_hash_map_t t) : result (hashmap_hash_map_t t) =
  begin match
    hashmap_hash_map_clear_slots_fwd_back t self.hashmap_hash_map_slots with
  | Fail e -> Fail e
  | Return v ->
    Return (Mkhashmap_hash_map_t 0 self.hashmap_hash_map_max_load_factor
      self.hashmap_hash_map_max_load v)
  end

(** [hashmap_main::hashmap::HashMap::{0}::len] *)
let hashmap_hash_map_len_fwd
  (t : Type0) (self : hashmap_hash_map_t t) : result usize =
  Return self.hashmap_hash_map_num_entries

(** [hashmap_main::hashmap::HashMap::{0}::insert_in_list] *)
let rec hashmap_hash_map_insert_in_list_loop_fwd
  (t : Type0) (key : usize) (value : t) (ls : hashmap_list_t t) :
  Tot (result bool)
  (decreases (hashmap_hash_map_insert_in_list_decreases t key value ls))
  =
  begin match ls with
  | HashmapListCons ckey cvalue tl ->
    if ckey = key
    then Return false
    else hashmap_hash_map_insert_in_list_loop_fwd t key value tl
  | HashmapListNil -> Return true
  end

(** [hashmap_main::hashmap::HashMap::{0}::insert_in_list] *)
let hashmap_hash_map_insert_in_list_fwd
  (t : Type0) (key : usize) (value : t) (ls : hashmap_list_t t) : result bool =
  hashmap_hash_map_insert_in_list_loop_fwd t key value ls

(** [hashmap_main::hashmap::HashMap::{0}::insert_in_list] *)
let rec hashmap_hash_map_insert_in_list_loop_back
  (t : Type0) (key : usize) (value : t) (ls : hashmap_list_t t) :
  Tot (result (hashmap_list_t t))
  (decreases (hashmap_hash_map_insert_in_list_decreases t key value ls))
  =
  begin match ls with
  | HashmapListCons ckey cvalue tl ->
    if ckey = key
    then Return (HashmapListCons ckey value tl)
    else
      begin match hashmap_hash_map_insert_in_list_loop_back t key value tl with
      | Fail e -> Fail e
      | Return l -> Return (HashmapListCons ckey cvalue l)
      end
  | HashmapListNil ->
    let l = HashmapListNil in Return (HashmapListCons key value l)
  end

(** [hashmap_main::hashmap::HashMap::{0}::insert_in_list] *)
let hashmap_hash_map_insert_in_list_back
  (t : Type0) (key : usize) (value : t) (ls : hashmap_list_t t) :
  result (hashmap_list_t t)
  =
  hashmap_hash_map_insert_in_list_loop_back t key value ls

(** [hashmap_main::hashmap::HashMap::{0}::insert_no_resize] *)
let hashmap_hash_map_insert_no_resize_fwd_back
  (t : Type0) (self : hashmap_hash_map_t t) (key : usize) (value : t) :
  result (hashmap_hash_map_t t)
  =
  begin match hashmap_hash_key_fwd key with
  | Fail e -> Fail e
  | Return hash ->
    let i = vec_len (hashmap_list_t t) self.hashmap_hash_map_slots in
    begin match usize_rem hash i with
    | Fail e -> Fail e
    | Return hash_mod ->
      begin match
        vec_index_mut_fwd (hashmap_list_t t) self.hashmap_hash_map_slots
          hash_mod with
      | Fail e -> Fail e
      | Return l ->
        begin match hashmap_hash_map_insert_in_list_fwd t key value l with
        | Fail e -> Fail e
        | Return inserted ->
          if inserted
          then
            begin match usize_add self.hashmap_hash_map_num_entries 1 with
            | Fail e -> Fail e
            | Return i0 ->
              begin match hashmap_hash_map_insert_in_list_back t key value l
                with
              | Fail e -> Fail e
              | Return l0 ->
                begin match
                  vec_index_mut_back (hashmap_list_t t)
                    self.hashmap_hash_map_slots hash_mod l0 with
                | Fail e -> Fail e
                | Return v ->
                  Return (Mkhashmap_hash_map_t i0
                    self.hashmap_hash_map_max_load_factor
                    self.hashmap_hash_map_max_load v)
                end
              end
            end
          else
            begin match hashmap_hash_map_insert_in_list_back t key value l with
            | Fail e -> Fail e
            | Return l0 ->
              begin match
                vec_index_mut_back (hashmap_list_t t)
                  self.hashmap_hash_map_slots hash_mod l0 with
              | Fail e -> Fail e
              | Return v ->
                Return (Mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
                  self.hashmap_hash_map_max_load_factor
                  self.hashmap_hash_map_max_load v)
              end
            end
        end
      end
    end
  end

(** [core::num::u32::{9}::MAX] *)
let core_num_u32_max_body : result u32 = Return 4294967295
let core_num_u32_max_c : u32 = eval_global core_num_u32_max_body

(** [hashmap_main::hashmap::HashMap::{0}::move_elements_from_list] *)
let rec hashmap_hash_map_move_elements_from_list_loop_fwd_back
  (t : Type0) (ntable : hashmap_hash_map_t t) (ls : hashmap_list_t t) :
  Tot (result (hashmap_hash_map_t t))
  (decreases (hashmap_hash_map_move_elements_from_list_decreases t ntable ls))
  =
  begin match ls with
  | HashmapListCons k v tl ->
    begin match hashmap_hash_map_insert_no_resize_fwd_back t ntable k v with
    | Fail e -> Fail e
    | Return ntable0 ->
      hashmap_hash_map_move_elements_from_list_loop_fwd_back t ntable0 tl
    end
  | HashmapListNil -> Return ntable
  end

(** [hashmap_main::hashmap::HashMap::{0}::move_elements_from_list] *)
let hashmap_hash_map_move_elements_from_list_fwd_back
  (t : Type0) (ntable : hashmap_hash_map_t t) (ls : hashmap_list_t t) :
  result (hashmap_hash_map_t t)
  =
  hashmap_hash_map_move_elements_from_list_loop_fwd_back t ntable ls

(** [hashmap_main::hashmap::HashMap::{0}::move_elements] *)
let rec hashmap_hash_map_move_elements_loop_fwd_back
  (t : Type0) (ntable : hashmap_hash_map_t t) (slots : vec (hashmap_list_t t))
  (i : usize) :
  Tot (result ((hashmap_hash_map_t t) & (vec (hashmap_list_t t))))
  (decreases (hashmap_hash_map_move_elements_decreases t ntable slots i))
  =
  let i0 = vec_len (hashmap_list_t t) slots in
  if i < i0
  then
    begin match vec_index_mut_fwd (hashmap_list_t t) slots i with
    | Fail e -> Fail e
    | Return l ->
      let ls = mem_replace_fwd (hashmap_list_t t) l HashmapListNil in
      begin match hashmap_hash_map_move_elements_from_list_fwd_back t ntable ls
        with
      | Fail e -> Fail e
      | Return ntable0 ->
        begin match usize_add i 1 with
        | Fail e -> Fail e
        | Return i1 ->
          let l0 = mem_replace_back (hashmap_list_t t) l HashmapListNil in
          begin match vec_index_mut_back (hashmap_list_t t) slots i l0 with
          | Fail e -> Fail e
          | Return slots0 ->
            hashmap_hash_map_move_elements_loop_fwd_back t ntable0 slots0 i1
          end
        end
      end
    end
  else Return (ntable, slots)

(** [hashmap_main::hashmap::HashMap::{0}::move_elements] *)
let hashmap_hash_map_move_elements_fwd_back
  (t : Type0) (ntable : hashmap_hash_map_t t) (slots : vec (hashmap_list_t t))
  (i : usize) :
  result ((hashmap_hash_map_t t) & (vec (hashmap_list_t t)))
  =
  hashmap_hash_map_move_elements_loop_fwd_back t ntable slots i

(** [hashmap_main::hashmap::HashMap::{0}::try_resize] *)
let hashmap_hash_map_try_resize_fwd_back
  (t : Type0) (self : hashmap_hash_map_t t) : result (hashmap_hash_map_t t) =
  begin match scalar_cast U32 Usize core_num_u32_max_c with
  | Fail e -> Fail e
  | Return max_usize ->
    let capacity = vec_len (hashmap_list_t t) self.hashmap_hash_map_slots in
    begin match usize_div max_usize 2 with
    | Fail e -> Fail e
    | Return n1 ->
      let (i, i0) = self.hashmap_hash_map_max_load_factor in
      begin match usize_div n1 i with
      | Fail e -> Fail e
      | Return i1 ->
        if capacity <= i1
        then
          begin match usize_mul capacity 2 with
          | Fail e -> Fail e
          | Return i2 ->
            begin match hashmap_hash_map_new_with_capacity_fwd t i2 i i0 with
            | Fail e -> Fail e
            | Return ntable ->
              begin match
                hashmap_hash_map_move_elements_fwd_back t ntable
                  self.hashmap_hash_map_slots 0 with
              | Fail e -> Fail e
              | Return (ntable0, _) ->
                Return (Mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
                  (i, i0) ntable0.hashmap_hash_map_max_load
                  ntable0.hashmap_hash_map_slots)
              end
            end
          end
        else
          Return (Mkhashmap_hash_map_t self.hashmap_hash_map_num_entries (i,
            i0) self.hashmap_hash_map_max_load self.hashmap_hash_map_slots)
      end
    end
  end

(** [hashmap_main::hashmap::HashMap::{0}::insert] *)
let hashmap_hash_map_insert_fwd_back
  (t : Type0) (self : hashmap_hash_map_t t) (key : usize) (value : t) :
  result (hashmap_hash_map_t t)
  =
  begin match hashmap_hash_map_insert_no_resize_fwd_back t self key value with
  | Fail e -> Fail e
  | Return self0 ->
    begin match hashmap_hash_map_len_fwd t self0 with
    | Fail e -> Fail e
    | Return i ->
      if i > self0.hashmap_hash_map_max_load
      then hashmap_hash_map_try_resize_fwd_back t self0
      else Return self0
    end
  end

(** [hashmap_main::hashmap::HashMap::{0}::contains_key_in_list] *)
let rec hashmap_hash_map_contains_key_in_list_loop_fwd
  (t : Type0) (key : usize) (ls : hashmap_list_t t) :
  Tot (result bool)
  (decreases (hashmap_hash_map_contains_key_in_list_decreases t key ls))
  =
  begin match ls with
  | HashmapListCons ckey x tl ->
    if ckey = key
    then Return true
    else hashmap_hash_map_contains_key_in_list_loop_fwd t key tl
  | HashmapListNil -> Return false
  end

(** [hashmap_main::hashmap::HashMap::{0}::contains_key_in_list] *)
let hashmap_hash_map_contains_key_in_list_fwd
  (t : Type0) (key : usize) (ls : hashmap_list_t t) : result bool =
  hashmap_hash_map_contains_key_in_list_loop_fwd t key ls

(** [hashmap_main::hashmap::HashMap::{0}::contains_key] *)
let hashmap_hash_map_contains_key_fwd
  (t : Type0) (self : hashmap_hash_map_t t) (key : usize) : result bool =
  begin match hashmap_hash_key_fwd key with
  | Fail e -> Fail e
  | Return hash ->
    let i = vec_len (hashmap_list_t t) self.hashmap_hash_map_slots in
    begin match usize_rem hash i with
    | Fail e -> Fail e
    | Return hash_mod ->
      begin match
        vec_index_fwd (hashmap_list_t t) self.hashmap_hash_map_slots hash_mod
        with
      | Fail e -> Fail e
      | Return l -> hashmap_hash_map_contains_key_in_list_fwd t key l
      end
    end
  end

(** [hashmap_main::hashmap::HashMap::{0}::get_in_list] *)
let rec hashmap_hash_map_get_in_list_loop_fwd
  (t : Type0) (key : usize) (ls : hashmap_list_t t) :
  Tot (result t) (decreases (hashmap_hash_map_get_in_list_decreases t key ls))
  =
  begin match ls with
  | HashmapListCons ckey cvalue tl ->
    if ckey = key
    then Return cvalue
    else hashmap_hash_map_get_in_list_loop_fwd t key tl
  | HashmapListNil -> Fail Failure
  end

(** [hashmap_main::hashmap::HashMap::{0}::get_in_list] *)
let hashmap_hash_map_get_in_list_fwd
  (t : Type0) (key : usize) (ls : hashmap_list_t t) : result t =
  hashmap_hash_map_get_in_list_loop_fwd t key ls

(** [hashmap_main::hashmap::HashMap::{0}::get] *)
let hashmap_hash_map_get_fwd
  (t : Type0) (self : hashmap_hash_map_t t) (key : usize) : result t =
  begin match hashmap_hash_key_fwd key with
  | Fail e -> Fail e
  | Return hash ->
    let i = vec_len (hashmap_list_t t) self.hashmap_hash_map_slots in
    begin match usize_rem hash i with
    | Fail e -> Fail e
    | Return hash_mod ->
      begin match
        vec_index_fwd (hashmap_list_t t) self.hashmap_hash_map_slots hash_mod
        with
      | Fail e -> Fail e
      | Return l -> hashmap_hash_map_get_in_list_fwd t key l
      end
    end
  end

(** [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] *)
let rec hashmap_hash_map_get_mut_in_list_loop_fwd
  (t : Type0) (key : usize) (ls : hashmap_list_t t) :
  Tot (result t)
  (decreases (hashmap_hash_map_get_mut_in_list_decreases t key ls))
  =
  begin match ls with
  | HashmapListCons ckey cvalue tl ->
    if ckey = key
    then Return cvalue
    else hashmap_hash_map_get_mut_in_list_loop_fwd t key tl
  | HashmapListNil -> Fail Failure
  end

(** [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] *)
let hashmap_hash_map_get_mut_in_list_fwd
  (t : Type0) (ls : hashmap_list_t t) (key : usize) : result t =
  hashmap_hash_map_get_mut_in_list_loop_fwd t key ls

(** [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] *)
let rec hashmap_hash_map_get_mut_in_list_loop_back
  (t : Type0) (key : usize) (ls : hashmap_list_t t) (ret : t) :
  Tot (result (hashmap_list_t t))
  (decreases (hashmap_hash_map_get_mut_in_list_decreases t key ls))
  =
  begin match ls with
  | HashmapListCons ckey cvalue tl ->
    if ckey = key
    then Return (HashmapListCons ckey ret tl)
    else
      begin match hashmap_hash_map_get_mut_in_list_loop_back t key tl ret with
      | Fail e -> Fail e
      | Return l -> Return (HashmapListCons ckey cvalue l)
      end
  | HashmapListNil -> Fail Failure
  end

(** [hashmap_main::hashmap::HashMap::{0}::get_mut_in_list] *)
let hashmap_hash_map_get_mut_in_list_back
  (t : Type0) (ls : hashmap_list_t t) (key : usize) (ret : t) :
  result (hashmap_list_t t)
  =
  hashmap_hash_map_get_mut_in_list_loop_back t key ls ret

(** [hashmap_main::hashmap::HashMap::{0}::get_mut] *)
let hashmap_hash_map_get_mut_fwd
  (t : Type0) (self : hashmap_hash_map_t t) (key : usize) : result t =
  begin match hashmap_hash_key_fwd key with
  | Fail e -> Fail e
  | Return hash ->
    let i = vec_len (hashmap_list_t t) self.hashmap_hash_map_slots in
    begin match usize_rem hash i with
    | Fail e -> Fail e
    | Return hash_mod ->
      begin match
        vec_index_mut_fwd (hashmap_list_t t) self.hashmap_hash_map_slots
          hash_mod with
      | Fail e -> Fail e
      | Return l -> hashmap_hash_map_get_mut_in_list_fwd t l key
      end
    end
  end

(** [hashmap_main::hashmap::HashMap::{0}::get_mut] *)
let hashmap_hash_map_get_mut_back
  (t : Type0) (self : hashmap_hash_map_t t) (key : usize) (ret : t) :
  result (hashmap_hash_map_t t)
  =
  begin match hashmap_hash_key_fwd key with
  | Fail e -> Fail e
  | Return hash ->
    let i = vec_len (hashmap_list_t t) self.hashmap_hash_map_slots in
    begin match usize_rem hash i with
    | Fail e -> Fail e
    | Return hash_mod ->
      begin match
        vec_index_mut_fwd (hashmap_list_t t) self.hashmap_hash_map_slots
          hash_mod with
      | Fail e -> Fail e
      | Return l ->
        begin match hashmap_hash_map_get_mut_in_list_back t l key ret with
        | Fail e -> Fail e
        | Return l0 ->
          begin match
            vec_index_mut_back (hashmap_list_t t) self.hashmap_hash_map_slots
              hash_mod l0 with
          | Fail e -> Fail e
          | Return v ->
            Return (Mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
              self.hashmap_hash_map_max_load_factor
              self.hashmap_hash_map_max_load v)
          end
        end
      end
    end
  end

(** [hashmap_main::hashmap::HashMap::{0}::remove_from_list] *)
let rec hashmap_hash_map_remove_from_list_loop_fwd
  (t : Type0) (key : usize) (ls : hashmap_list_t t) :
  Tot (result (option t))
  (decreases (hashmap_hash_map_remove_from_list_decreases t key ls))
  =
  begin match ls with
  | HashmapListCons ckey x tl ->
    if ckey = key
    then
      let mv_ls =
        mem_replace_fwd (hashmap_list_t t) (HashmapListCons ckey x tl)
          HashmapListNil in
      begin match mv_ls with
      | HashmapListCons i cvalue tl0 -> Return (Some cvalue)
      | HashmapListNil -> Fail Failure
      end
    else hashmap_hash_map_remove_from_list_loop_fwd t key tl
  | HashmapListNil -> Return None
  end

(** [hashmap_main::hashmap::HashMap::{0}::remove_from_list] *)
let hashmap_hash_map_remove_from_list_fwd
  (t : Type0) (key : usize) (ls : hashmap_list_t t) : result (option t) =
  hashmap_hash_map_remove_from_list_loop_fwd t key ls

(** [hashmap_main::hashmap::HashMap::{0}::remove_from_list] *)
let rec hashmap_hash_map_remove_from_list_loop_back
  (t : Type0) (key : usize) (ls : hashmap_list_t t) :
  Tot (result (hashmap_list_t t))
  (decreases (hashmap_hash_map_remove_from_list_decreases t key ls))
  =
  begin match ls with
  | HashmapListCons ckey x tl ->
    if ckey = key
    then
      let mv_ls =
        mem_replace_fwd (hashmap_list_t t) (HashmapListCons ckey x tl)
          HashmapListNil in
      begin match mv_ls with
      | HashmapListCons i cvalue tl0 -> Return tl0
      | HashmapListNil -> Fail Failure
      end
    else
      begin match hashmap_hash_map_remove_from_list_loop_back t key tl with
      | Fail e -> Fail e
      | Return l -> Return (HashmapListCons ckey x l)
      end
  | HashmapListNil -> Return HashmapListNil
  end

(** [hashmap_main::hashmap::HashMap::{0}::remove_from_list] *)
let hashmap_hash_map_remove_from_list_back
  (t : Type0) (key : usize) (ls : hashmap_list_t t) :
  result (hashmap_list_t t)
  =
  hashmap_hash_map_remove_from_list_loop_back t key ls

(** [hashmap_main::hashmap::HashMap::{0}::remove] *)
let hashmap_hash_map_remove_fwd
  (t : Type0) (self : hashmap_hash_map_t t) (key : usize) : result (option t) =
  begin match hashmap_hash_key_fwd key with
  | Fail e -> Fail e
  | Return hash ->
    let i = vec_len (hashmap_list_t t) self.hashmap_hash_map_slots in
    begin match usize_rem hash i with
    | Fail e -> Fail e
    | Return hash_mod ->
      begin match
        vec_index_mut_fwd (hashmap_list_t t) self.hashmap_hash_map_slots
          hash_mod with
      | Fail e -> Fail e
      | Return l ->
        begin match hashmap_hash_map_remove_from_list_fwd t key l with
        | Fail e -> Fail e
        | Return x ->
          begin match x with
          | None -> Return None
          | Some x0 ->
            begin match usize_sub self.hashmap_hash_map_num_entries 1 with
            | Fail e -> Fail e
            | Return _ -> Return (Some x0)
            end
          end
        end
      end
    end
  end

(** [hashmap_main::hashmap::HashMap::{0}::remove] *)
let hashmap_hash_map_remove_back
  (t : Type0) (self : hashmap_hash_map_t t) (key : usize) :
  result (hashmap_hash_map_t t)
  =
  begin match hashmap_hash_key_fwd key with
  | Fail e -> Fail e
  | Return hash ->
    let i = vec_len (hashmap_list_t t) self.hashmap_hash_map_slots in
    begin match usize_rem hash i with
    | Fail e -> Fail e
    | Return hash_mod ->
      begin match
        vec_index_mut_fwd (hashmap_list_t t) self.hashmap_hash_map_slots
          hash_mod with
      | Fail e -> Fail e
      | Return l ->
        begin match hashmap_hash_map_remove_from_list_fwd t key l with
        | Fail e -> Fail e
        | Return x ->
          begin match x with
          | None ->
            begin match hashmap_hash_map_remove_from_list_back t key l with
            | Fail e -> Fail e
            | Return l0 ->
              begin match
                vec_index_mut_back (hashmap_list_t t)
                  self.hashmap_hash_map_slots hash_mod l0 with
              | Fail e -> Fail e
              | Return v ->
                Return (Mkhashmap_hash_map_t self.hashmap_hash_map_num_entries
                  self.hashmap_hash_map_max_load_factor
                  self.hashmap_hash_map_max_load v)
              end
            end
          | Some x0 ->
            begin match usize_sub self.hashmap_hash_map_num_entries 1 with
            | Fail e -> Fail e
            | Return i0 ->
              begin match hashmap_hash_map_remove_from_list_back t key l with
              | Fail e -> Fail e
              | Return l0 ->
                begin match
                  vec_index_mut_back (hashmap_list_t t)
                    self.hashmap_hash_map_slots hash_mod l0 with
                | Fail e -> Fail e
                | Return v ->
                  Return (Mkhashmap_hash_map_t i0
                    self.hashmap_hash_map_max_load_factor
                    self.hashmap_hash_map_max_load v)
                end
              end
            end
          end
        end
      end
    end
  end

(** [hashmap_main::hashmap::test1] *)
let hashmap_test1_fwd : result unit =
  begin match hashmap_hash_map_new_fwd u64 with
  | Fail e -> Fail e
  | Return hm ->
    begin match hashmap_hash_map_insert_fwd_back u64 hm 0 42 with
    | Fail e -> Fail e
    | Return hm0 ->
      begin match hashmap_hash_map_insert_fwd_back u64 hm0 128 18 with
      | Fail e -> Fail e
      | Return hm1 ->
        begin match hashmap_hash_map_insert_fwd_back u64 hm1 1024 138 with
        | Fail e -> Fail e
        | Return hm2 ->
          begin match hashmap_hash_map_insert_fwd_back u64 hm2 1056 256 with
          | Fail e -> Fail e
          | Return hm3 ->
            begin match hashmap_hash_map_get_fwd u64 hm3 128 with
            | Fail e -> Fail e
            | Return i ->
              if not (i = 18)
              then Fail Failure
              else
                begin match hashmap_hash_map_get_mut_back u64 hm3 1024 56 with
                | Fail e -> Fail e
                | Return hm4 ->
                  begin match hashmap_hash_map_get_fwd u64 hm4 1024 with
                  | Fail e -> Fail e
                  | Return i0 ->
                    if not (i0 = 56)
                    then Fail Failure
                    else
                      begin match hashmap_hash_map_remove_fwd u64 hm4 1024 with
                      | Fail e -> Fail e
                      | Return x ->
                        begin match x with
                        | None -> Fail Failure
                        | Some x0 ->
                          if not (x0 = 56)
                          then Fail Failure
                          else
                            begin match
                              hashmap_hash_map_remove_back u64 hm4 1024 with
                            | Fail e -> Fail e
                            | Return hm5 ->
                              begin match hashmap_hash_map_get_fwd u64 hm5 0
                                with
                              | Fail e -> Fail e
                              | Return i1 ->
                                if not (i1 = 42)
                                then Fail Failure
                                else
                                  begin match
                                    hashmap_hash_map_get_fwd u64 hm5 128 with
                                  | Fail e -> Fail e
                                  | Return i2 ->
                                    if not (i2 = 18)
                                    then Fail Failure
                                    else
                                      begin match
                                        hashmap_hash_map_get_fwd u64 hm5 1056
                                        with
                                      | Fail e -> Fail e
                                      | Return i3 ->
                                        if not (i3 = 256)
                                        then Fail Failure
                                        else Return ()
                                      end
                                  end
                              end
                            end
                        end
                      end
                  end
                end
            end
          end
        end
      end
    end
  end

(** Unit test for [hashmap_main::hashmap::test1] *)
let _ = assert_norm (hashmap_test1_fwd = Return ())

(** [hashmap_main::insert_on_disk] *)
let insert_on_disk_fwd
  (key : usize) (value : u64) (st : state) : result (state & unit) =
  begin match hashmap_utils_deserialize_fwd st with
  | Fail e -> Fail e
  | Return (st0, hm) ->
    begin match hashmap_hash_map_insert_fwd_back u64 hm key value with
    | Fail e -> Fail e
    | Return hm0 ->
      begin match hashmap_utils_serialize_fwd hm0 st0 with
      | Fail e -> Fail e
      | Return (st1, _) -> Return (st1, ())
      end
    end
  end

(** [hashmap_main::main] *)
let main_fwd : result unit = Return ()

(** Unit test for [hashmap_main::main] *)
let _ = assert_norm (main_fwd = Return ())


(** THIS FILE WAS AUTOMATICALLY GENERATED BY AENEAS *)
(** [loops]: function definitions *)
module Loops.Funs
open Primitives
include Loops.Types
include Loops.Clauses

#set-options "--z3rlimit 50 --fuel 1 --ifuel 1"

(** [loops::sum] *)
let rec sum_loop_fwd
  (max : u32) (i : u32) (s : u32) :
  Tot (result u32) (decreases (sum_decreases max i s))
  =
  if i < max
  then
    begin match u32_add s i with
    | Fail e -> Fail e
    | Return s0 ->
      begin match u32_add i 1 with
      | Fail e -> Fail e
      | Return i0 -> sum_loop_fwd max i0 s0
      end
    end
  else u32_mul s 2

(** [loops::sum] *)
let sum_fwd (max : u32) : result u32 = sum_loop_fwd max 0 0

(** [loops::sum_with_mut_borrows] *)
let rec sum_with_mut_borrows_loop_fwd
  (max : u32) (mi : u32) (ms : u32) :
  Tot (result u32) (decreases (sum_with_mut_borrows_decreases max mi ms))
  =
  if mi < max
  then
    begin match u32_add ms mi with
    | Fail e -> Fail e
    | Return ms0 ->
      begin match u32_add mi 1 with
      | Fail e -> Fail e
      | Return mi0 -> sum_with_mut_borrows_loop_fwd max mi0 ms0
      end
    end
  else u32_mul ms 2

(** [loops::sum_with_mut_borrows] *)
let sum_with_mut_borrows_fwd (max : u32) : result u32 =
  sum_with_mut_borrows_loop_fwd max 0 0

(** [loops::sum_with_shared_borrows] *)
let rec sum_with_shared_borrows_loop_fwd
  (max : u32) (i : u32) (s : u32) :
  Tot (result u32) (decreases (sum_with_shared_borrows_decreases max i s))
  =
  if i < max
  then
    begin match u32_add i 1 with
    | Fail e -> Fail e
    | Return i0 ->
      begin match u32_add s i0 with
      | Fail e -> Fail e
      | Return s0 -> sum_with_shared_borrows_loop_fwd max i0 s0
      end
    end
  else u32_mul s 2

(** [loops::sum_with_shared_borrows] *)
let sum_with_shared_borrows_fwd (max : u32) : result u32 =
  sum_with_shared_borrows_loop_fwd max 0 0

(** [loops::clear] *)
let rec clear_loop_fwd_back
  (v : vec u32) (i : usize) :
  Tot (result (vec u32)) (decreases (clear_decreases v i))
  =
  let i0 = vec_len u32 v in
  if i < i0
  then
    begin match usize_add i 1 with
    | Fail e -> Fail e
    | Return i1 ->
      begin match vec_index_mut_back u32 v i 0 with
      | Fail e -> Fail e
      | Return v0 -> clear_loop_fwd_back v0 i1
      end
    end
  else Return v

(** [loops::clear] *)
let clear_fwd_back (v : vec u32) : result (vec u32) = clear_loop_fwd_back v 0

(** [loops::list_mem] *)
let rec list_mem_loop_fwd
  (x : u32) (ls : list_t u32) :
  Tot (result bool) (decreases (list_mem_decreases x ls))
  =
  begin match ls with
  | ListCons y tl -> if y = x then Return true else list_mem_loop_fwd x tl
  | ListNil -> Return false
  end

(** [loops::list_mem] *)
let list_mem_fwd (x : u32) (ls : list_t u32) : result bool =
  list_mem_loop_fwd x ls

(** [loops::list_nth_mut_loop] *)
let rec list_nth_mut_loop_loop_fwd
  (t : Type0) (ls : list_t t) (i : u32) :
  Tot (result t) (decreases (list_nth_mut_loop_decreases t ls i))
  =
  begin match ls with
  | ListCons x tl ->
    if i = 0
    then Return x
    else
      begin match u32_sub i 1 with
      | Fail e -> Fail e
      | Return i0 -> list_nth_mut_loop_loop_fwd t tl i0
      end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_loop] *)
let list_nth_mut_loop_fwd (t : Type0) (ls : list_t t) (i : u32) : result t =
  list_nth_mut_loop_loop_fwd t ls i

(** [loops::list_nth_mut_loop] *)
let rec list_nth_mut_loop_loop_back
  (t : Type0) (ls : list_t t) (i : u32) (ret : t) :
  Tot (result (list_t t)) (decreases (list_nth_mut_loop_decreases t ls i))
  =
  begin match ls with
  | ListCons x tl ->
    if i = 0
    then Return (ListCons ret tl)
    else
      begin match u32_sub i 1 with
      | Fail e -> Fail e
      | Return i0 ->
        begin match list_nth_mut_loop_loop_back t tl i0 ret with
        | Fail e -> Fail e
        | Return l -> Return (ListCons x l)
        end
      end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_loop] *)
let list_nth_mut_loop_back
  (t : Type0) (ls : list_t t) (i : u32) (ret : t) : result (list_t t) =
  list_nth_mut_loop_loop_back t ls i ret

(** [loops::list_nth_shared_loop] *)
let rec list_nth_shared_loop_loop_fwd
  (t : Type0) (ls : list_t t) (i : u32) :
  Tot (result t) (decreases (list_nth_shared_loop_decreases t ls i))
  =
  begin match ls with
  | ListCons x tl ->
    if i = 0
    then Return x
    else
      begin match u32_sub i 1 with
      | Fail e -> Fail e
      | Return i0 -> list_nth_shared_loop_loop_fwd t tl i0
      end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_shared_loop] *)
let list_nth_shared_loop_fwd (t : Type0) (ls : list_t t) (i : u32) : result t =
  list_nth_shared_loop_loop_fwd t ls i

(** [loops::get_elem_mut] *)
let rec get_elem_mut_loop_fwd
  (x : usize) (ls : list_t usize) :
  Tot (result usize) (decreases (get_elem_mut_decreases x ls))
  =
  begin match ls with
  | ListCons y tl -> if y = x then Return y else get_elem_mut_loop_fwd x tl
  | ListNil -> Fail Failure
  end

(** [loops::get_elem_mut] *)
let get_elem_mut_fwd (slots : vec (list_t usize)) (x : usize) : result usize =
  begin match vec_index_mut_fwd (list_t usize) slots 0 with
  | Fail e -> Fail e
  | Return l -> get_elem_mut_loop_fwd x l
  end

(** [loops::get_elem_mut] *)
let rec get_elem_mut_loop_back
  (x : usize) (ls : list_t usize) (ret : usize) :
  Tot (result (list_t usize)) (decreases (get_elem_mut_decreases x ls))
  =
  begin match ls with
  | ListCons y tl ->
    if y = x
    then Return (ListCons ret tl)
    else
      begin match get_elem_mut_loop_back x tl ret with
      | Fail e -> Fail e
      | Return l -> Return (ListCons y l)
      end
  | ListNil -> Fail Failure
  end

(** [loops::get_elem_mut] *)
let get_elem_mut_back
  (slots : vec (list_t usize)) (x : usize) (ret : usize) :
  result (vec (list_t usize))
  =
  begin match vec_index_mut_fwd (list_t usize) slots 0 with
  | Fail e -> Fail e
  | Return l ->
    begin match get_elem_mut_loop_back x l ret with
    | Fail e -> Fail e
    | Return l0 -> vec_index_mut_back (list_t usize) slots 0 l0
    end
  end

(** [loops::get_elem_shared] *)
let rec get_elem_shared_loop_fwd
  (x : usize) (slots : vec (list_t usize)) (ls : list_t usize)
  (ls0 : list_t usize) :
  Tot (result usize) (decreases (get_elem_shared_decreases x slots ls ls0))
  =
  begin match ls0 with
  | ListCons y tl ->
    if y = x then Return y else get_elem_shared_loop_fwd x slots ls tl
  | ListNil -> Fail Failure
  end

(** [loops::get_elem_shared] *)
let get_elem_shared_fwd
  (slots : vec (list_t usize)) (x : usize) : result usize =
  begin match vec_index_fwd (list_t usize) slots 0 with
  | Fail e -> Fail e
  | Return l -> get_elem_shared_loop_fwd x slots l l
  end

(** [loops::id_mut] *)
let id_mut_fwd (t : Type0) (ls : list_t t) : result (list_t t) = Return ls

(** [loops::id_mut] *)
let id_mut_back
  (t : Type0) (ls : list_t t) (ret : list_t t) : result (list_t t) =
  Return ret

(** [loops::id_shared] *)
let id_shared_fwd (t : Type0) (ls : list_t t) : result (list_t t) = Return ls

(** [loops::list_nth_mut_loop_with_id] *)
let rec list_nth_mut_loop_with_id_loop_fwd
  (t : Type0) (i : u32) (ls : list_t t) :
  Tot (result t) (decreases (list_nth_mut_loop_with_id_decreases t i ls))
  =
  begin match ls with
  | ListCons x tl ->
    if i = 0
    then Return x
    else
      begin match u32_sub i 1 with
      | Fail e -> Fail e
      | Return i0 -> list_nth_mut_loop_with_id_loop_fwd t i0 tl
      end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_loop_with_id] *)
let list_nth_mut_loop_with_id_fwd
  (t : Type0) (ls : list_t t) (i : u32) : result t =
  begin match id_mut_fwd t ls with
  | Fail e -> Fail e
  | Return ls0 -> list_nth_mut_loop_with_id_loop_fwd t i ls0
  end

(** [loops::list_nth_mut_loop_with_id] *)
let rec list_nth_mut_loop_with_id_loop_back
  (t : Type0) (i : u32) (ls : list_t t) (ret : t) :
  Tot (result (list_t t))
  (decreases (list_nth_mut_loop_with_id_decreases t i ls))
  =
  begin match ls with
  | ListCons x tl ->
    if i = 0
    then Return (ListCons ret tl)
    else
      begin match u32_sub i 1 with
      | Fail e -> Fail e
      | Return i0 ->
        begin match list_nth_mut_loop_with_id_loop_back t i0 tl ret with
        | Fail e -> Fail e
        | Return l -> Return (ListCons x l)
        end
      end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_loop_with_id] *)
let list_nth_mut_loop_with_id_back
  (t : Type0) (ls : list_t t) (i : u32) (ret : t) : result (list_t t) =
  begin match id_mut_fwd t ls with
  | Fail e -> Fail e
  | Return ls0 ->
    begin match list_nth_mut_loop_with_id_loop_back t i ls0 ret with
    | Fail e -> Fail e
    | Return l -> id_mut_back t ls l
    end
  end

(** [loops::list_nth_shared_loop_with_id] *)
let rec list_nth_shared_loop_with_id_loop_fwd
  (t : Type0) (ls : list_t t) (i : u32) (ls0 : list_t t) :
  Tot (result t)
  (decreases (list_nth_shared_loop_with_id_decreases t ls i ls0))
  =
  begin match ls0 with
  | ListCons x tl ->
    if i = 0
    then Return x
    else
      begin match u32_sub i 1 with
      | Fail e -> Fail e
      | Return i0 -> list_nth_shared_loop_with_id_loop_fwd t ls i0 tl
      end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_shared_loop_with_id] *)
let list_nth_shared_loop_with_id_fwd
  (t : Type0) (ls : list_t t) (i : u32) : result t =
  begin match id_shared_fwd t ls with
  | Fail e -> Fail e
  | Return ls0 -> list_nth_shared_loop_with_id_loop_fwd t ls i ls0
  end

(** [loops::list_nth_mut_loop_pair] *)
let rec list_nth_mut_loop_pair_loop_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) :
  Tot (result (t & t))
  (decreases (list_nth_mut_loop_pair_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (x0, x1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 -> list_nth_mut_loop_pair_loop_fwd t tl0 tl1 i0
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_loop_pair] *)
let list_nth_mut_loop_pair_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) : result (t & t) =
  list_nth_mut_loop_pair_loop_fwd t ls0 ls1 i

(** [loops::list_nth_mut_loop_pair] *)
let rec list_nth_mut_loop_pair_loop_back'a
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  Tot (result (list_t t))
  (decreases (list_nth_mut_loop_pair_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (ListCons ret tl0)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 ->
          begin match list_nth_mut_loop_pair_loop_back'a t tl0 tl1 i0 ret with
          | Fail e -> Fail e
          | Return l -> Return (ListCons x0 l)
          end
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_loop_pair] *)
let list_nth_mut_loop_pair_back'a
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  result (list_t t)
  =
  list_nth_mut_loop_pair_loop_back'a t ls0 ls1 i ret

(** [loops::list_nth_mut_loop_pair] *)
let rec list_nth_mut_loop_pair_loop_back'b
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  Tot (result (list_t t))
  (decreases (list_nth_mut_loop_pair_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (ListCons ret tl1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 ->
          begin match list_nth_mut_loop_pair_loop_back'b t tl0 tl1 i0 ret with
          | Fail e -> Fail e
          | Return l -> Return (ListCons x1 l)
          end
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_loop_pair] *)
let list_nth_mut_loop_pair_back'b
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  result (list_t t)
  =
  list_nth_mut_loop_pair_loop_back'b t ls0 ls1 i ret

(** [loops::list_nth_shared_loop_pair] *)
let rec list_nth_shared_loop_pair_loop_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) :
  Tot (result (t & t))
  (decreases (list_nth_shared_loop_pair_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (x0, x1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 -> list_nth_shared_loop_pair_loop_fwd t tl0 tl1 i0
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_shared_loop_pair] *)
let list_nth_shared_loop_pair_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) : result (t & t) =
  list_nth_shared_loop_pair_loop_fwd t ls0 ls1 i

(** [loops::list_nth_mut_loop_pair_merge] *)
let rec list_nth_mut_loop_pair_merge_loop_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) :
  Tot (result (t & t))
  (decreases (list_nth_mut_loop_pair_merge_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (x0, x1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 -> list_nth_mut_loop_pair_merge_loop_fwd t tl0 tl1 i0
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_loop_pair_merge] *)
let list_nth_mut_loop_pair_merge_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) : result (t & t) =
  list_nth_mut_loop_pair_merge_loop_fwd t ls0 ls1 i

(** [loops::list_nth_mut_loop_pair_merge] *)
let rec list_nth_mut_loop_pair_merge_loop_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : (t & t)) :
  Tot (result ((list_t t) & (list_t t)))
  (decreases (list_nth_mut_loop_pair_merge_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then let (x, x2) = ret in Return (ListCons x tl0, ListCons x2 tl1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 ->
          begin match list_nth_mut_loop_pair_merge_loop_back t tl0 tl1 i0 ret
            with
          | Fail e -> Fail e
          | Return (l, l0) -> Return (ListCons x0 l, ListCons x1 l0)
          end
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_loop_pair_merge] *)
let list_nth_mut_loop_pair_merge_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : (t & t)) :
  result ((list_t t) & (list_t t))
  =
  list_nth_mut_loop_pair_merge_loop_back t ls0 ls1 i ret

(** [loops::list_nth_shared_loop_pair_merge] *)
let rec list_nth_shared_loop_pair_merge_loop_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) :
  Tot (result (t & t))
  (decreases (list_nth_shared_loop_pair_merge_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (x0, x1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 -> list_nth_shared_loop_pair_merge_loop_fwd t tl0 tl1 i0
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_shared_loop_pair_merge] *)
let list_nth_shared_loop_pair_merge_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) : result (t & t) =
  list_nth_shared_loop_pair_merge_loop_fwd t ls0 ls1 i

(** [loops::list_nth_mut_shared_loop_pair] *)
let rec list_nth_mut_shared_loop_pair_loop_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) :
  Tot (result (t & t))
  (decreases (list_nth_mut_shared_loop_pair_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (x0, x1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 -> list_nth_mut_shared_loop_pair_loop_fwd t tl0 tl1 i0
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_shared_loop_pair] *)
let list_nth_mut_shared_loop_pair_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) : result (t & t) =
  list_nth_mut_shared_loop_pair_loop_fwd t ls0 ls1 i

(** [loops::list_nth_mut_shared_loop_pair] *)
let rec list_nth_mut_shared_loop_pair_loop_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  Tot (result (list_t t))
  (decreases (list_nth_mut_shared_loop_pair_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (ListCons ret tl0)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 ->
          begin match list_nth_mut_shared_loop_pair_loop_back t tl0 tl1 i0 ret
            with
          | Fail e -> Fail e
          | Return l -> Return (ListCons x0 l)
          end
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_shared_loop_pair] *)
let list_nth_mut_shared_loop_pair_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  result (list_t t)
  =
  list_nth_mut_shared_loop_pair_loop_back t ls0 ls1 i ret

(** [loops::list_nth_mut_shared_loop_pair_merge] *)
let rec list_nth_mut_shared_loop_pair_merge_loop_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) :
  Tot (result (t & t))
  (decreases (list_nth_mut_shared_loop_pair_merge_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (x0, x1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 ->
          list_nth_mut_shared_loop_pair_merge_loop_fwd t tl0 tl1 i0
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_shared_loop_pair_merge] *)
let list_nth_mut_shared_loop_pair_merge_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) : result (t & t) =
  list_nth_mut_shared_loop_pair_merge_loop_fwd t ls0 ls1 i

(** [loops::list_nth_mut_shared_loop_pair_merge] *)
let rec list_nth_mut_shared_loop_pair_merge_loop_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  Tot (result (list_t t))
  (decreases (list_nth_mut_shared_loop_pair_merge_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (ListCons ret tl0)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 ->
          begin match
            list_nth_mut_shared_loop_pair_merge_loop_back t tl0 tl1 i0 ret with
          | Fail e -> Fail e
          | Return l -> Return (ListCons x0 l)
          end
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_mut_shared_loop_pair_merge] *)
let list_nth_mut_shared_loop_pair_merge_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  result (list_t t)
  =
  list_nth_mut_shared_loop_pair_merge_loop_back t ls0 ls1 i ret

(** [loops::list_nth_shared_mut_loop_pair] *)
let rec list_nth_shared_mut_loop_pair_loop_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) :
  Tot (result (t & t))
  (decreases (list_nth_shared_mut_loop_pair_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (x0, x1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 -> list_nth_shared_mut_loop_pair_loop_fwd t tl0 tl1 i0
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_shared_mut_loop_pair] *)
let list_nth_shared_mut_loop_pair_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) : result (t & t) =
  list_nth_shared_mut_loop_pair_loop_fwd t ls0 ls1 i

(** [loops::list_nth_shared_mut_loop_pair] *)
let rec list_nth_shared_mut_loop_pair_loop_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  Tot (result (list_t t))
  (decreases (list_nth_shared_mut_loop_pair_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (ListCons ret tl1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 ->
          begin match list_nth_shared_mut_loop_pair_loop_back t tl0 tl1 i0 ret
            with
          | Fail e -> Fail e
          | Return l -> Return (ListCons x1 l)
          end
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_shared_mut_loop_pair] *)
let list_nth_shared_mut_loop_pair_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  result (list_t t)
  =
  list_nth_shared_mut_loop_pair_loop_back t ls0 ls1 i ret

(** [loops::list_nth_shared_mut_loop_pair_merge] *)
let rec list_nth_shared_mut_loop_pair_merge_loop_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) :
  Tot (result (t & t))
  (decreases (list_nth_shared_mut_loop_pair_merge_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (x0, x1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 ->
          list_nth_shared_mut_loop_pair_merge_loop_fwd t tl0 tl1 i0
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_shared_mut_loop_pair_merge] *)
let list_nth_shared_mut_loop_pair_merge_fwd
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) : result (t & t) =
  list_nth_shared_mut_loop_pair_merge_loop_fwd t ls0 ls1 i

(** [loops::list_nth_shared_mut_loop_pair_merge] *)
let rec list_nth_shared_mut_loop_pair_merge_loop_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  Tot (result (list_t t))
  (decreases (list_nth_shared_mut_loop_pair_merge_decreases t ls0 ls1 i))
  =
  begin match ls0 with
  | ListCons x0 tl0 ->
    begin match ls1 with
    | ListCons x1 tl1 ->
      if i = 0
      then Return (ListCons ret tl1)
      else
        begin match u32_sub i 1 with
        | Fail e -> Fail e
        | Return i0 ->
          begin match
            list_nth_shared_mut_loop_pair_merge_loop_back t tl0 tl1 i0 ret with
          | Fail e -> Fail e
          | Return l -> Return (ListCons x1 l)
          end
        end
    | ListNil -> Fail Failure
    end
  | ListNil -> Fail Failure
  end

(** [loops::list_nth_shared_mut_loop_pair_merge] *)
let list_nth_shared_mut_loop_pair_merge_back
  (t : Type0) (ls0 : list_t t) (ls1 : list_t t) (i : u32) (ret : t) :
  result (list_t t)
  =
  list_nth_shared_mut_loop_pair_merge_loop_back t ls0 ls1 i ret


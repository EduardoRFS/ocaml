/***********************************************************************/
/*                                                                     */
/*                                OCaml                                */
/*                                                                     */
/*            Damien Doligez, projet Para, INRIA Rocquencourt          */
/*                                                                     */
/*  Copyright 1997 Institut National de Recherche en Informatique et   */
/*  en Automatique.  All rights reserved.  This file is distributed    */
/*  under the terms of the GNU Library General Public License, with    */
/*  the special exception on linking described in file ../LICENSE.     */
/*                                                                     */
/***********************************************************************/

/* Operations on weak arrays */

#ifndef CAML_WEAK_H
#define CAML_WEAK_H

#ifdef CAML_INTERNALS

#include "mlvalues.h"

extern value caml_ephe_none;

#define CAML_EPHE_LINK_OFFSET 0
#define CAML_EPHE_DOMAIN_OFFSET 1
#define CAML_EPHE_DATA_OFFSET 2
#define CAML_EPHE_FIRST_KEY 3

/** The first field 0:  weak list;
       second field 1:  owning domain;
        third field 2:  data;
       others       3..:  keys;

    A weak pointer is an ephemeron with the data at caml_ephe_none
    If fields are added, don't forget to update weak.ml [additional_values].
 */

#define Ephe_link(e) (*(Op_val(e) + CAML_EPHE_LINK_OFFSET))
#define Ephe_domain(e) (*(struct domain**)(Op_val(e) + CAML_EPHE_DOMAIN_OFFSET))
#define Ephe_data(e) (*(Op_val(e) + CAML_EPHE_DATA_OFFSET))

void caml_ephe_clean(value e);

#endif /* CAML_INTERNALS */

#endif /* CAML_WEAK_H */

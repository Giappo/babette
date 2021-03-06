% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/bbt_run.R
\name{bbt_run}
\alias{bbt_run}
\title{Do a full run: create a BEAST2 configuration file (like BEAUti 2),
run BEAST2, parse results (like Tracer)}
\usage{
bbt_run(
  fasta_filename,
  tipdates_filename = NA,
  site_model = beautier::create_jc69_site_model(),
  clock_model = beautier::create_strict_clock_model(),
  tree_prior = beautier::create_yule_tree_prior(),
  mrca_prior = NA,
  mcmc = beautier::create_mcmc(),
  beast2_input_filename = tempfile(pattern = "beast2_", fileext = ".xml"),
  rng_seed = 1,
  beast2_output_log_filename = tempfile(
    pattern = "beast2_", fileext = "log"
  ),
  beast2_output_trees_filenames = tempfile(
    pattern = paste0(
      "beast2_",
      beautier::get_alignment_ids(fasta_filename), "_"
    ),
    fileext = ".trees"
  ),
  beast2_output_state_filename = tempfile(
    pattern = "beast2_", fileext = ".xml.state"
  ),
  beast2_path = beastier::get_default_beast2_path(),
  overwrite = FALSE,
  verbose = FALSE,
  fasta_filenames = "deprecated",
  site_models = "deprecated",
  clock_models = "deprecated",
  tree_priors = "deprecated",
  mrca_priors = "deprecated",
  posterior_crown_age = "deprecated",
  cleanup = "deprecated"
)
}
\arguments{
\item{fasta_filename}{a FASTA filename}

\item{tipdates_filename}{name of the file containing tip dates}

\item{site_model}{one site model,
see \link[beautier]{create_site_models}}

\item{clock_model}{one clock model,
see \link[beautier]{create_clock_model}}

\item{tree_prior}{one tree priors,
as created by \link[beautier]{create_tree_prior}}

\item{mrca_prior}{one Most Recent Common Ancestor prior,
as returned by \code{\link{create_mrca_prior}}}

\item{mcmc}{the MCMC options,
see \link[beautier]{create_mcmc}}

\item{beast2_input_filename}{path of the BEAST2 configuration file.
By default, this file is put in a temporary folder with a random
filename, as the user needs not read it: it is used as input of BEAST2.
Specifying a \code{beast2_input_filename} allows to store that file
in a more permanently stored location.}

\item{rng_seed}{the random number generator seed. Must be either
\code{NA} or a positive non-zero value. An RNG seed of \code{NA}
results in BEAST2 picking a random seed.}

\item{beast2_output_log_filename}{name of the log file created by BEAST2,
containing the parameter estimates in time. By default, this
file is put a temporary folder with a random
filename, as the user needs not read it: its content
is parsed and returned by this function.
Specifying a \code{beast2_output_log_filename} allows to store that file
in a more permanently stored location.}

\item{beast2_output_trees_filenames}{name of the one or more trees
files created by BEAST2, one per alignment. By default, these
files are put a temporary folder with a random
filename, as the user needs not read it: their content
is parsed and returned by this function.
Specifying \code{beast2_output_trees_filenames} allows to store these
one or more files in a more permanently stored location.}

\item{beast2_output_state_filename}{name of the final state file created
by BEAST2, containing the operator acceptances. By default, this
file is put a temporary folder with a random
filename, as the user needs not read it: its content
is parsed and returned by this function.
Specifying a \code{beast2_output_state_filename} allows to store that file
in a more permanently stored location.}

\item{beast2_path}{name of either a BEAST2 binary file
(usually simply \code{beast})
or a BEAST2 jar file
(usually has a \code{.jar} extension).
Use \code{get_default_beast2_bin_path} to get
the default BEAST binary file's path
Use \code{get_default_beast2_jar_path} to get
the default BEAST jar file's path}

\item{overwrite}{if TRUE: overwrite the \code{.log}
 and \code{.trees} files if one of these exists.
 If FALSE, BEAST2 will not be started if
 \itemize{
   \item{the \code{.log} file exists}
   \item{the \code{.trees} files exist}
   \item{the \code{.log} file created by BEAST2 exists}
   \item{the \code{.trees} files created by BEAST2 exist}
}}

\item{verbose}{set to TRUE for more output}

\item{fasta_filenames}{one or more FASTA filename, each with one alignment}

\item{site_models}{one or more site models,
see \link[beautier]{create_site_models}}

\item{clock_models}{one or more clock models,
see \link[beautier]{create_clock_models}}

\item{tree_priors}{one or more tree priors,
see \link[beautier]{create_tree_priors}}

\item{mrca_priors}{a list of one or more Most Recent Common Ancestor priors,
as returned by \code{\link{create_mrca_prior}}}

\item{posterior_crown_age}{deprecated}

\item{cleanup}{set to FALSE to keep all temporary files}
}
\value{
a list with the following elements:\cr
\itemize{
  \item{
    \code{estimates}: a data frame with BEAST2
    parameter estimates
  }
  \item{
    \code{[alignment_id]_trees}: a \code{multiPhylo}
    containing the phylogenies
    in the BEAST2 posterior. \code{[alignment_id]}
    is the ID of the alignment. For example,
    when running \code{bbt_run} with
    \code{anthus_aco.fas}, this element will have
    name \code{anthus_aco_trees}
  }
  \item{
    \code{operators}: a data frame with the
    BEAST2 MCMC operator acceptances
  }
  \item{
    \code{output}: a numeric vector with the output
    sent to standard output and error streams
  }
  \item{
    \code{ns}: (optional) the results of a marginal likelihood estimation,
    will exist only when \code{create_mcmc_nested_sampling} was
    used for \code{mcmc}.
    This structure will contain the following elements:
    \itemize{
      \item \code{marg_log_lik} the marginal log likelihood estimate
      \item \code{marg_log_lik_sd} the standard deviation around the estimate
      \item \code{estimates} the parameter estimates
        created during the marginal likelihood estimation
      \item \code{trees} the trees
        created during the marginal likelihood estimation
    }
  }
}
}
\description{
Do a full run: create a BEAST2 configuration file (like BEAUti 2),
run BEAST2, parse results (like Tracer)
}
\examples{
 out <- bbt_run(
   fasta_filename = get_babette_path("anthus_aco.fas"),
   mcmc = create_mcmc(chain_length = 1000, store_every = 1000)
 )

 testit::assert("estimates" \%in\% names(out))
 testit::assert("anthus_aco_trees" \%in\% names(out))
 testit::assert("operators" \%in\% names(out))
 testit::assert("output" \%in\% names(out))
 testit::assert(class(out$anthus_aco_trees[[1]]) == "phylo")
 testit::assert(length(out$anthus_aco_trees) == 2)

 testit::assert("Sample" \%in\% names(out$estimates))
 testit::assert("posterior" \%in\% names(out$estimates))
 testit::assert("likelihood" \%in\% names(out$estimates))
 testit::assert("prior" \%in\% names(out$estimates))
 testit::assert("treeLikelihood" \%in\% names(out$estimates))
 testit::assert("TreeHeight" \%in\% names(out$estimates))
 testit::assert("YuleModel" \%in\% names(out$estimates))
 testit::assert("birthRate" \%in\% names(out$estimates))

 testit::assert("operator" \%in\% names(out$operators))
 testit::assert("p" \%in\% names(out$operators))
 testit::assert("accept" \%in\% names(out$operators))
 testit::assert("reject" \%in\% names(out$operators))
 testit::assert("acceptFC" \%in\% names(out$operators))
 testit::assert("rejectFC" \%in\% names(out$operators))
 testit::assert("rejectIv" \%in\% names(out$operators))
 testit::assert("rejectOp" \%in\% names(out$operators))
}
\seealso{
Use \code{\link[tracerer]{remove_burn_ins}}
  to remove the burn-ins from
  the posterior's estimates (\code{posterior$estimates})
}
\author{
Richel J.C. Bilderbeek
}

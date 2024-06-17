resource "vercel_project" "website2_project" {
  name      = "website2"
  framework = "nextjs"
  team_id   = "${var.vercel_team_id}"
  git_repository = {
    type = "github"
    repo = "jdc18/monorepo-example"
  }
  build_command   = "pnpm run build"
  install_command = "pnpm install"
  root_directory  = "packages/website2"
  ignore_command  = "git diff HEAD^ HEAD --quiet ./"
}

resource "vercel_project_domain" "website2_project" {
  project_id = vercel_project.website2_project.id
  domain     = "website2.${var.domain_name}"
  team_id    = "${var.vercel_team_id}"
}

resource "vercel_project_environment_variable" "website2_project_next_public_backend" {
  project_id = vercel_project.website2_project.id
  team_id    = "${var.vercel_team_id}"
  key        = "NEXT_PUBLIC_BACKEND"
  value      = "api.${var.domain_name}"
  target     = ["production"]
}
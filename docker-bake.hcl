variable "GO_VERSION" {
  default = "1.18"
}

variable "TAG" {
  default = "latest"
}

target "_common" {
  args = {
    GO_VERSION = GO_VERSION
    BUILDKIT_CONTEXT_KEEP_GIT_DIR = 1
  }
}

// docker-bake.hcl
target "docker-metadata-action" {
  tags = ["devopps/hello-world-buildx:${TAG}"]
}

group "default" {
  targets = ["image"]
}

target "image" {
 inherits = ["_common", "docker-metadata-action"]
 context = "."
 dockerfile = "Dockerfile"
 cache-from = ["type=registry,ref=${GITHUB_REPOSITORY_OWNER}/hello-world-buildx:latest"]
 cache-to = ["type=inline"]
 labels = {
   "org.opencontainers.image.title"= "hello-world-buildx"
   "org.opencontainers.image.ref" = "https://github.com/foo/myapp"
 }
 output = ["type=registry"]
}

target "image-all" {
 inherits = ["image"]
 platforms = ["linux/amd64", "linux/arm64", "linux/arm/v6", "linux/arm/v7"]
 output = ["type=registry"]
}

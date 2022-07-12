variable "GO_VERSION" {
  default = "1.18"
}

variable "TAG" {
  default = "v0.0.0"
}

target "_common" {
  args = {
    GO_VERSION = GO_VERSION
    BUILDKIT_CONTEXT_KEEP_GIT_DIR = 1
  }
}


group "default" {
  targets = ["image"]
}

target "tag" {
  tags = ["devopps/hello-world-buildx:${TAG}"]
}

target "image" {
 inherits = ["_common", "tag"]
 context = "."
 dockerfile = "Dockerfile"
 cache-from = ["type=registry,ref=devopps/hello-world-buildx:latest"]
 cache-to = ["type=inline"]
 labels = {
   "org.opencontainers.image.title"= "hello-world-buildx"
   "org.opencontainers.image.ref" = "https://github.com/foo/myapp"
 }
 tags = [
   "devopps/hello-world-buildx:bake"
 ]
 output = ["type=registry"]
}

target "image-all" {
 inherits = ["image"]
 platforms = ["linux/amd64", "linux/arm64", "linux/arm/v6", "linux/arm/v7"]
 output = ["type=registry"]
}

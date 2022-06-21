group "default" {
  targets = ["image"]
}

variable "TAG" {
  default = "v0.0.0"
}

target "tag" {
  tags = ["devopps/hello-world-buildx:${TAG}"]
}

target "image" {
 inherits = ["tag"]
 context = "."
 dockerfile = "Dockerfile"
 cache-from = ["type=registry,ref=devopps/hello-world-buildx:latest"] 
 cache-to = ["type=registry,ref=devopps/hello-world-build:latest"]
 labels = {
   "org.opencontainers.image.title" = "hello-world-buildx"
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

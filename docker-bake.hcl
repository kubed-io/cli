variable "TAG" {
    default = "1.0.0"
}

variable "REGISTRY" {
    default = "kubed"
}

group "default" {
    targets = ["kubed-cli"]
}

target "kubed-cli" {
    tags = [
        "${REGISTRY}/cli:latest",
        "${REGISTRY}/cli:${TAG}"
    ]
    platforms = [
        "linux/amd64",
        "linux/arm64/v8"
    ]
}

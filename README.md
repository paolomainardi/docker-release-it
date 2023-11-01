# Dockerised Release-it

A simple container to run release-it with a set of opinionated modules.

At the time of writing it contains (because i need it) the following dependencies:

```json
{
  "dependencies": {
    "@release-it/bumper": "^5.1.0",
    "@release-it/keep-a-changelog": "^4.0.0",
    "release-it": "^16.2.1"
  }
}
```

## Usage

It is possible to run the container with the following command:

```bash
> make build
> docker run --rm paolomainardi/release-it --version
```

The entrypoint is set to `release-it` so it is possible to pass any argument to the container.

```bash
> docker run --rm paolomainardi/release-it --help
```

To run a shell inside the container:

```bash
> docker run --rm -it paolomainardi/release-it shell
```


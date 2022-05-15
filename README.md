# Docker Files

This is a collection of Docker files I keep around for running various applications (GUI and non-GUI) in Docker.

## Intro
In the folder `/baseimage`, you'll find the images that form the base of all actual application images. In these
base images, several configuration steps like adding a user with a home, setting `LC_` variables and time zone etc,
have been configured. That's mostly stuff that all other images need, although a few X libraries are added in there that are
irrelevant for console applications.

For each image, there's a build script which sets the adequate build args and creates the image under the `mrnerd`
namespace.

To make it easier to adapt the images to your needs, the build scripts source a `.env` file at the root of this
repository. Since that file might contain private information, I'm only including an `.env.example` file so
you can roll your own.

## Images

* [baseimage](baseimage): Base images with Ubuntu, mostly a LTS version plus a newer version for packages that are not
  available in the LTS version.
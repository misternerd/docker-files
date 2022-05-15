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

I also provide example run scripts to show which Docker parameters one needs to add. Especially for GUI applications,
you need to mount a wealth of files into the container to get things like DBus and Pulse Audio working. Especially for
Chromium/Electron based applications, this holds true.

## Images

* [baseimage](baseimage): Base images with Ubuntu, mostly a LTS version plus a newer version for packages that are not
  available in the LTS version.
* [brave](brave): The Brave browser, which is based on Chromium. Especially since Ubuntu started using Snap for
  Chromium, this is a more feasible approach to install a browser with Chrome Dev Tools. Great for web development if
  you want to be absolutely positive that nothing was cached by the browser. Or change settings like language etc and
  then just close the browser instead of settings things back. 
* [Chrome](chrome) Useful for DRM related testing, as it already bundles Widevine. Also bundles security fixes faster
  than Brave, which might be a pro for security related tasks.
* [OpenVPN](openvpn): Runs OpenVPN in a container, allows other containers to connect to the Internet through
  the VPN connection. Check out the [README](openvpn/README.md) in the subfolder.
* [youtube-dl](youtube-dl): Allows downloading media from different Internet sites
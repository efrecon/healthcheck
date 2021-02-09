# Effortless `HEALTHCHECK` capable redis

This [image][https://hub.docker.com/r/efrecon/redis] is to capture all possible
(now, then and future) tags of the redis image and to arrange for creating an
equivalent image with the same tag, but `HEALTHCHECK`-capabilities built in.  To
check for available tags, refer to the official
[image](https://hub.docker.com/_/redis/).

## How

This "fools" the build process by hijacking two of the available [hooks], namely
`build` and `push`. Instead of picking the tag from data coming from settings
entered within the hub or the Docker Cloud, both hooks will go and fetch the
current list of listed tags from the github [project][redis]. The implementation
is generic enough to be applied to any other official Docker image from the
library.

  [hooks]: https://docs.docker.com/docker-cloud/builds/advanced/#custom-build-phase-hooks
  [redis]: https://github.com/docker-library/official-images/blob/master/library/redis

Once these hooks have been defined, it is possible to make the image dependent
of the official redis library so that it will recreate all tags and images as
soon as anything new has been pushed to it. This is less resource intensive as
it sounds as Docker will typically cache most layers. Consequently, out of all
the tags that are extracted each time, only a few layers are reconstructed.

In addition, the implementation uses the OCI label
[`org.opencontainers.image.revision`][revision] to detect changes. The label
will be set to the relevant git revision in this repository. Change detection
and image building will only happen for images that have a different checksum.
New images from the original image will not yet exist and have an empty label,
thus triggering the build process.

Changes to the main [redis] are detected through a gitlab project running
[talonneur] and storing relevant sums using [snippets].

  [revision]: https://github.com/opencontainers/image-spec/blob/master/annotations.md#pre-defined-annotation-keys
  [talonneur]: https://github.com/YanziNetworks/talonneur
  [snippet]: https://docs.gitlab.com/ee/user/snippets.html#project-snippets

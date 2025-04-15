${{ content_synopsis }} Block most ads from most websites, have entire categories blocked on your or other networks or for individual clients. Perfect for parents and enterprises alike.

${{ content_uvp }} Good question! All the other images on the market that do exactly the same don’t do or offer these options:

${{ github:> [!IMPORTANT] }}
${{ github:> }}* This image runs as 1000:1000 by default, most other images run everything as root
${{ github:> }}* This image has no shell since it is 100% distroless, most other images run on a distro like Debian or Alpine with full shell access (security)
${{ github:> }}* This image is created via a secure, pinned CI/CD process and immune to upstream attacks, most other images have upstream dependencies that can be exploited
${{ github:> }}* This image contains a proper health check that verifies the app is actually working, most other images have either no health check or only check if a port is open or ping works
${{ github:> }}* This image works as read-only, most other images need to write files to the image filesystem

If you value security, simplicity and the ability to interact with the maintainer and developer of an image. Using my images is a great start in that direction.

${{ title_volumes }}
* **${{ json_root }}/var** - Directory of all dynamic data and configurations

${{ content_compose }}

${{ content_defaults }}
| `login` | admin // traefik | login using compose example |

${{ content_environment }}

${{ content_source }}

${{ content_parent }}

${{ content_built }}

${{ content_tips }}

${{ title_caution }}
${{ github:> [!CAUTION] }}
${{ github:> }}* If you use the compose example as a base for your individual configuration, please make sure to change the default dashboard login account password
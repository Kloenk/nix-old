{ callPackage, fetchgit, lib }:

import (fetchgit (lib.importJSON ./source.json))

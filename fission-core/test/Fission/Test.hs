module Fission.Test (spec) where

import           Fission.Test.Prelude

import qualified Fission.Test.DNS           as DNS
import qualified Fission.Test.Environment   as Environment
import qualified Fission.Test.Internal.Bool as Bool
import qualified Fission.Test.Internal.UTF8 as UTF8
import qualified Fission.Test.Random        as Random
import qualified Fission.Test.URL           as URL
import qualified Fission.Test.User.DID      as DID
import qualified Fission.Test.Web.Server.Auth.Token.Bearer              as Bearer
import qualified Fission.Test.Web.Server.Auth.Token.JWT                 as JWT

import qualified Fission.Test.Web.Server.Auth.Token.UCAN.Resource       as Resource
import qualified Fission.Test.Web.Server.Auth.Token.UCAN.Resource.Scope as Scope

import qualified Fission.Test.Web.Server.Auth.Signature.Ed25519         as Ed

spec :: Spec
spec =
  describe "Fission" do
    Bool.spec
    DID.spec
    DNS.spec
    Environment.spec
    Random.spec
    URL.spec
    UTF8.spec

    -- UCAN tests
    Bearer.spec
    Ed.spec
    JWT.spec
    Resource.spec
    Scope.spec

module Fission.Test.Web.Auth.Token.JWT (spec) where

import qualified Data.Aeson                                       as JSON
import qualified Data.ByteString.Lazy.Char8                       as Lazy.Char8
import qualified RIO.ByteString.Lazy                              as Lazy
import           Servant.API

import qualified Fission.Internal.UTF8                            as UTF8
-- import           Fission.Web.Auth.Token.JWT
import           Fission.Web.Auth.Token.JWT.Fact.Types
import           Fission.Web.Auth.Token.UCAN.Resource.Scope.Types
import           Fission.Web.Auth.Token.UCAN.Resource.Types
import           Web.Ucan.Types

import           Fission.Test.Prelude
import qualified Fission.Test.Web.Auth.Token.JWT.Validation       as Validation

import qualified Fission.Test.Web.Auth.Token.JWT.Proof            as Proof

spec :: Spec
spec =
  describe "Fission.Web.Auth.Token.JWT" do
    Proof.spec
    Validation.spec

    describe "Header serialization" do
      itsProp' "text serialization is unquoted JSON" \(jwt :: JWT Fact (Scope Resource)) ->
        jwt
          |> toUrlPiece
          |> UTF8.wrapIn "\""
          |> encodeUtf8
          |> Lazy.fromStrict
          |> shouldBe (JSON.encode jwt)

    describe "JSON serialization" do
      itsProp' "serialized is isomorphic to ADT" \(jwt :: JWT Fact (Scope Resource)) ->
        JSON.eitherDecode (JSON.encode jwt) `shouldBe` Right jwt

      describe "format" do
        itsProp' "contains exactly two '.'s" \(jwt :: JWT Fact (Scope Resource)) ->
          jwt
            |> JSON.encode
            |> Lazy.count (fromIntegral $ ord '.')
            |> shouldBe 2

        itsProp' "contains only valid base64 URL characters" \(jwt :: JWT Fact (Scope Resource)) ->
          let
            encoded = JSON.encode jwt
          in
            encoded
              |> Lazy.take (Lazy.length encoded - 2)
              |> Lazy.drop 2
              |> Lazy.filter (not . isValidChar)
              |> shouldBe mempty

isValidChar :: Word8 -> Bool
isValidChar w8 = Lazy.elem w8 validB64URLChars

validB64URLChars :: Lazy.ByteString
validB64URLChars = Lazy.Char8.pack chars
  where
    chars :: [Char]
    chars = ['a'..'z']
         <> ['A'..'Z']
         <> ['0'..'9']
         <> ['_', '-', '.']

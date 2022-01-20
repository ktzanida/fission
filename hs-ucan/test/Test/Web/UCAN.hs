module Test.Web.UCAN (spec) where

import qualified Data.Aeson                        as JSON
import qualified Data.ByteString.Lazy.Char8        as Lazy.Char8
import qualified RIO.ByteString.Lazy               as Lazy
import qualified Web.UCAN.Internal.UTF8            as UTF8
import           Web.UCAN.Types

import           Test.Web.UCAN.Prelude

import qualified Test.Web.UCAN.DelegationSemantics as DelegationSemantics
import           Test.Web.UCAN.Example


spec :: Spec
spec =
  describe "Web.UCAN" do
    describe "serialization" do
      itsProp' "serialized is isomorphic to ADT" \(ucan :: UCAN () Resource Potency) ->
        JSON.eitherDecode (JSON.encode ucan) `shouldBe` Right ucan

      describe "format" do
        itsProp' "contains exactly two '.'s" \(ucan :: UCAN () Resource Potency) ->
          ucan
            |> JSON.encode
            |> Lazy.count (fromIntegral $ ord '.')
            |> shouldBe 2

        itsProp' "contains only valid base64 URL characters" \(ucan :: Fission.UCAN) ->
          let
            encoded = JSON.encode ucan
          in
            encoded
              |> Lazy.take (Lazy.length encoded - 2)
              |> Lazy.drop 2
              |> Lazy.filter (not . isValidChar)
              |> shouldBe mempty

    describe "DelegationSemantics" do
      describe "Resource" do
        DelegationSemantics.partialOrderProperties @Resource

      describe "Potency" do
        DelegationSemantics.partialOrderProperties @Potency

      describe "Maybe _" do
        DelegationSemantics.partialOrderProperties @(Maybe Potency)


isValidChar :: Word8 -> Bool
isValidChar w8 = Lazy.elem w8 (" " <> validEncodedJWTChars)

validEncodedJWTChars :: Lazy.ByteString
validEncodedJWTChars = Lazy.Char8.pack (base64URLChars <> ['.']) -- dot is used as a separator in JWTs
  where
    base64URLChars :: [Char]
    base64URLChars =
         ['a'..'z']
      <> ['A'..'Z']
      <> ['0'..'9']
      <> ['_', '-']

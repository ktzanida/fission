module Web.UCAN.Error (Error (..)) where

import           Data.Aeson
import           RIO

import qualified Web.UCAN.Claims.Error    as Claims
import qualified Web.UCAN.Header.Error    as Header
import qualified Web.UCAN.Signature.Error as Signature

data Error
  = ParseError
  | HeaderError    Header.Error
  | ClaimsError    Claims.Error
  | SignatureError Signature.Error
  deriving ( Exception
           , Eq
           , Show
           )

instance ToJSON Error where
  toJSON = String . textDisplay

instance Display Error where
  display = \case
    ParseError         -> "Could not parse JWT"
    HeaderError    err -> "JWT header error: "    <> display err
    SignatureError err -> "JWT signature error: " <> display err
    ClaimsError    err -> "JWT claims error: "    <> display err

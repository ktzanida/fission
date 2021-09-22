module Fission.Test.Web.Server.Auth.Token.JWT.Validation (spec) where

import qualified Data.Aeson                             as JSON
import           Network.HTTP.Client.TLS                as HTTP

import qualified Fission.Internal.Fixture.Bearer        as Fixture
import qualified Fission.Internal.Fixture.Bearer.Nested as Nested.Fixture

import           Fission.Web.Auth.Token.JWT.Types       as JWT
import qualified Fission.Web.Auth.Token.JWT.Validation  as JWT

import           Fission.Test.Web.Server.Prelude
import           Fission.User.DID.Types

import           Fission.Internal.Fixture.Time

import           Fission.Web.Auth.Token.JWT.Resolver    as Proof

spec :: Spec
spec =
  describe "JWT Validation" do
    -- return ()
    -- context "RSA 2048" do
      -- FIXME when we have a functioning real world case
      -- context "real world bearer token" do
      --   it "is valid" do
      --     JWT.pureChecks Fixture.rawContent Fixture.jwtRSA2048
      --       `shouldBe` Right Fixture.jwtRSA2048

      -- context "real world nested bearer token -- end to end" do
      --   it "is valid" do
      --     JWT.check Nested.Fixture.rawContent Nested.Fixture.jwtRSA2048
      --       `shouldBe` Nested.Fixture.InTimeBounds (pure $ Right Nested.Fixture.jwtRSA2048)

     describe "ION" do
       it "is valid 1" do   --    $ runIO do
         mgr    <- HTTP.newTlsManager
         result <- runIonic $ JWT.check mgr serverDID ionContent1 ionUCAN1
         result `shouldBe` Right ionUCAN1

       it "is valid 2" do   --    $ runIO do
         mgr    <- HTTP.newTlsManager
         result <- runIonic $ JWT.check mgr serverDID ionContent2 ionUCAN2
         result `shouldBe` Right ionUCAN2

       it "is valid 3" do   --    $ runIO do
         mgr    <- HTTP.newTlsManager
         result <- runIonic $ JWT.checkWithION mgr serverDID ionContent3 ionUCAN3 agesAgo
         isRight result `shouldBe` True

ionContent1 :: JWT.RawContent
ionContent1 = JWT.RawContent "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCIsInVhdiI6IjEuMC4wIn0.eyJhdWQiOiJkaWQ6a2V5OnpTdEVacHpTTXRUdDlrMnZzemd2Q3dGNGZMUVFTeUExNVc1QVE0ejNBUjZCeDRlRko1Y3JKRmJ1R3hLbWJtYTQiLCJleHAiOjE2MzI0MDg5MTMsImZjdCI6W10sImlzcyI6ImRpZDppb246RWlBWFl0WU9zRlBYSzlyRXc5eGJMand3UG42VmotVWlvRnZSUlgxM01CSU5lUSIsIm5iZiI6MTYzMjMyMjQ1MywicHJmIjpudWxsLCJwdGMiOiJBUFBFTkQiLCJyc2MiOiIqIn0"

ionRaw1 :: ByteString
ionRaw1 = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCIsInVhdiI6IjEuMC4wIn0.eyJhdWQiOiJkaWQ6a2V5OnpTdEVacHpTTXRUdDlrMnZzemd2Q3dGNGZMUVFTeUExNVc1QVE0ejNBUjZCeDRlRko1Y3JKRmJ1R3hLbWJtYTQiLCJleHAiOjE2MzI0MDg5MTMsImZjdCI6W10sImlzcyI6ImRpZDppb246RWlBWFl0WU9zRlBYSzlyRXc5eGJMand3UG42VmotVWlvRnZSUlgxM01CSU5lUSIsIm5iZiI6MTYzMjMyMjQ1MywicHJmIjpudWxsLCJwdGMiOiJBUFBFTkQiLCJyc2MiOiIqIn0.oJ1S6j2nwSR3w6PC_pJnQ4FJjifq8SZKJx4kTcMkEGhghSkZdto5qNLpXQZ5UXGw8NPgdWw0AVszQVvxcdikCA"

ionUCAN1 :: JWT
Just ionUCAN1 = JSON.decodeStrict ("\""<> ionRaw1 <> "\"")

ionContent2 :: JWT.RawContent
ionContent2 = JWT.RawContent "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCIsInVhdiI6IjEuMC4wIn0.eyJhdWQiOiJkaWQ6a2V5OnpTdEVacHpTTXRUdDlrMnZzemd2Q3dGNGZMUVFTeUExNVc1QVE0ejNBUjZCeDRlRko1Y3JKRmJ1R3hLbWJtYTQiLCJleHAiOjE2MzI0MjI1ODcsImZjdCI6W10sImlzcyI6ImRpZDppb246RWlCMUthMkxSMjZPT3J0bUJqX0pjUnVSaGdHTm03R0dBRURIUkUtWUZSNHlqUSIsIm5iZiI6MTYzMjMzNjEyNywicHJmIjpudWxsLCJwdGMiOiJBUFBFTkQiLCJyc2MiOiIqIn0" -- "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCIsInVhdiI6IjEuMC4wIn0.eyJhdWQiOiJkaWQ6a2V5OnpTdEVacHpTTXRUdDlrMnZzemd2Q3dGNGZMUVFTeUExNVc1QVE0ejNBUjZCeDRlRko1Y3JKRmJ1R3hLbWJtYTQiLCJleHAiOjE2MzI0MTgyNDcsImZjdCI6W10sImlzcyI6ImRpZDppb246RWlCWTJkMGxuaWxEelZfVlB4VGYteWgtemNJamJ3bWNBY2gtYVZ2Q3MwX0NBZyIsIm5iZiI6MTYzMjMzMTc4NywicHJmIjpudWxsLCJwdGMiOiJBUFBFTkQiLCJyc2MiOiIqIn0"

ionRaw2 :: ByteString
ionRaw2 = "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCIsInVhdiI6IjEuMC4wIn0.eyJhdWQiOiJkaWQ6a2V5OnpTdEVacHpTTXRUdDlrMnZzemd2Q3dGNGZMUVFTeUExNVc1QVE0ejNBUjZCeDRlRko1Y3JKRmJ1R3hLbWJtYTQiLCJleHAiOjE2MzI0MjI1ODcsImZjdCI6W10sImlzcyI6ImRpZDppb246RWlCMUthMkxSMjZPT3J0bUJqX0pjUnVSaGdHTm03R0dBRURIUkUtWUZSNHlqUSIsIm5iZiI6MTYzMjMzNjEyNywicHJmIjpudWxsLCJwdGMiOiJBUFBFTkQiLCJyc2MiOiIqIn0.iYUd8rT5DbCnVv631gjOmi6nqx10Td05YqLNII8l3NAatdqL5ZY-LTJLkd2iylzYEhqNy_y4rIQqjmxhj0A3AA" -- "eyJhbGciOiJFZERTQSIsInR5cCI6IkpXVCIsInVhdiI6IjEuMC4wIn0.eyJhdWQiOiJkaWQ6a2V5OnpTdEVacHpTTXRUdDlrMnZzemd2Q3dGNGZMUVFTeUExNVc1QVE0ejNBUjZCeDRlRko1Y3JKRmJ1R3hLbWJtYTQiLCJleHAiOjE2MzI0MTgyNDcsImZjdCI6W10sImlzcyI6ImRpZDppb246RWlCWTJkMGxuaWxEelZfVlB4VGYteWgtemNJamJ3bWNBY2gtYVZ2Q3MwX0NBZyIsIm5iZiI6MTYzMjMzMTc4NywicHJmIjpudWxsLCJwdGMiOiJBUFBFTkQiLCJyc2MiOiIqIn0.hCqQ7AqQIAlJ-3NRHeqpe0wwQ1UEH2Bt9i0RpE1TcpJQV8bPBdve3C0tHu_sFWj4x8MdY5Hbf7O0-grtddeVCA"

ionUCAN2 :: JWT
Just ionUCAN2 = JSON.decodeStrict ("\""<> ionRaw2 <> "\"")

newtype IONIC a = IONIC { runIonic :: IO a }
  deriving newtype (Functor, Applicative, Monad, MonadIO, MonadTime)

instance Proof.Resolver IONIC where
  resolve _ = return . Left $ InvalidJWT "Should not hit this code path"

serverDID :: DID
Just serverDID = JSON.decode "\"did:key:z6MkgYGF3thn8k1Fv4p4dWXKtsXCnLH7q9yw4QgNPULDmDKB\""

ionContent3 :: JWT.RawContent
ionContent3 = JWT.RawContent "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsInVhdiI6IjEuMC4wIn0.eyJhdWQiOiJkaWQ6a2V5OnpTdEVacHpTTXRUdDlrMnZzemd2Q3dGNGZMUVFTeUExNVc1QVE0ejNBUjZCeDRlRko1Y3JKRmJ1R3hLbWJtYTQiLCJleHAiOjE2MzIzNDc1ODksImZjdCI6W10sImlzcyI6ImRpZDprZXk6ejEzVjNTb2cyWWFVS2hkR0NtZ3g5VVp1VzFvMVNoRkpZYzZEdkdZZTdOVHQ2ODlOb0wyUlN1ZWNDMlFnalVIcGlvN3FNRHdxTXNNY21QZXRTdHdZR1ptdnlSSENBclBaQ3pjTEVpUTNVeERLYzFaV0d4MjZmRFlndkRLQktWYm5GbzNzRHNSQWU2TkN5dWlETlEyQmp2NGl0cEN3YkNHdVRaYm0zdmJpU2ZkYzZONXBOMzl5Z1NvRmEzQzQ5WWVVYTROYVJLU1ZrTU5idFFvRllmOFM0QTU2TTNhVnVKYVNrZUg1TkprS0E4V1pIaWh3UTFqb3ppZ3N2M21FbkNqRFF4VGszTXM5am5XN2hpaW1ORFlSdnJjSjhFUEZoc01UcWp1R004ZVhIY3Z4MzkxOER6Uml6RHBOdmFuVU51Rm9RTFJjemd3R1VlSFJhZTVreFltN25vUWJoaVJ6SnUyOHdtb1Y0d0RFNzgzYndLbVI5RXNoVXpqb2RMbkhhdFZjbkdVb2dmWWlqZEVaMUplS25wdWtYdnAiLCJuYmYiOjE2MzIzNDc1MDAsInByZiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSTZJa3BYVkNJc0luVmhkaUk2SWpFdU1DNHdJbjAuZXlKaGRXUWlPaUprYVdRNmEyVjVPbm94TTFZelUyOW5NbGxoVlV0b1pFZERiV2Q0T1ZWYWRWY3hiekZUYUVaS1dXTTJSSFpIV1dVM1RsUjBOamc1VG05TU1sSlRkV1ZqUXpKUloycFZTSEJwYnpkeFRVUjNjVTF6VFdOdFVHVjBVM1IzV1VkYWJYWjVVa2hEUVhKUVdrTjZZMHhGYVZFelZYaEVTMk14V2xkSGVESTJaa1JaWjNaRVMwSkxWbUp1Um04emMwUnpVa0ZsTms1RGVYVnBSRTVSTWtKcWRqUnBkSEJEZDJKRFIzVlVXbUp0TTNaaWFWTm1aR00yVGpWd1RqTTVlV2RUYjBaaE0wTTBPVmxsVldFMFRtRlNTMU5XYTAxT1luUlJiMFpaWmpoVE5FRTFOazB6WVZaMVNtRlRhMlZJTlU1S2EwdEJPRmRhU0dsb2QxRXhhbTk2YVdkemRqTnRSVzVEYWtSUmVGUnJNMDF6T1dwdVZ6ZG9hV2x0VGtSWlVuWnlZMG80UlZCR2FITk5WSEZxZFVkTk9HVllTR04yZURNNU1UaEVlbEpwZWtSd1RuWmhibFZPZFVadlVVeFNZM3BuZDBkVlpVaFNZV1UxYTNoWmJUZHViMUZpYUdsU2VrcDFNamgzYlc5V05IZEVSVGM0TTJKM1MyMVNPVVZ6YUZWNmFtOWtURzVJWVhSV1kyNUhWVzluWmxscGFtUkZXakZLWlV0dWNIVnJXSFp3SWl3aVpYaHdJam94TmpNeU16UTNOVGc1TENKbVkzUWlPbHRkTENKcGMzTWlPaUprYVdRNmEyVjVPbm94TTFZelUyOW5NbGxoVlV0b1pFZERiV2Q0T1ZWYWRWY3hiekZUYUVaS1dXTTJSSFpIV1dVM1RsUjBOamc1VG05TU1sSlRkV1ZqUXpKUloycFZTSEJwYnpkeFRVUjNjVTF6VFdOdFVHVjBVM1IzV1VkYWJYWjVVa2hEUVhKUVdrTjZZMHhGYVZFelZYaEVTMk14V2xkSGVESTJaa1JaWjNaRVMwSkxWbUp1Um04emMwUnpVa0ZsTms1RGVYVnBSRTVSTWtKcWRqUnBkSEJEZDJKRFIzVlVXbUp0TTNaaWFWTm1aR00yVGpWd1RqTTVlV2RUYjBaaE0wTTBPVmxsVldFMFRtRlNTMU5XYTAxT1luUlJiMFpaWmpoVE5FRTFOazB6WVZaMVNtRlRhMlZJTlU1S2EwdEJPRmRhU0dsb2QxRXhhbTk2YVdkemRqTnRSVzVEYWtSUmVGUnJNMDF6T1dwdVZ6ZG9hV2x0VGtSWlVuWnlZMG80UlZCR2FITk5WSEZxZFVkTk9HVllTR04yZURNNU1UaEVlbEpwZWtSd1RuWmhibFZPZFVadlVVeFNZM3BuZDBkVlpVaFNZV1UxYTNoWmJUZHViMUZpYUdsU2VrcDFNamgzYlc5V05IZEVSVGM0TTJKM1MyMVNPVVZ6YUZWNmFtOWtURzVJWVhSV1kyNUhWVzluWmxscGFtUkZXakZLWlV0dWNIVnJXSFp3SWl3aWJtSm1Jam94TmpNeU16UTNORGs1TENKd2NtWWlPaUpsZVVwb1lrZGphVTlwU2taYVJWSlVVVk5KYzBsdVVqVmpRMGsyU1d0d1dGWkRTWE5KYmxab1pHbEpOa2xxUlhWTlF6UjNTVzR3TG1WNVNtaGtWMUZwVDJsS2EyRlhVVFpoTWxZMVQyNXZlRTB4V1hwVk1qbHVUV3hzYUZaVmRHOWFSV1JFWWxka05FOVdWbUZrVm1ONFlucEdWR0ZGV2t0WFYwMHlVa2hhU0ZkWFZUTlViRkl3VG1wbk5WUnRPVTFOYkVwVVpGZFdhbEY2U2xKYU1uQldVMGhDY0dKNlpIaFVWVkl6WTFVeGVsUlhUblJWUjFZd1ZUTlNNMWRWWkdGaVdGbzFWV3RvUkZGWVNsRlhhMDQyV1RCNFJtRldSWHBXV0doRlV6Sk5lRmRzWkVobFJFa3lXbXRTV2xveldrVlRNRXBNVm0xS2RWSnRPSHBqTUZKNlZXdEdiRTVyTlVSbFdGWndVa1UxVWsxclNuRmthbEp3WkVoQ1JHUXlTa1JTTTFaVlYyMUtkRTB6V21saFZrNXRXa2ROTWxScVZuZFVhazAxWlZka1ZHSXdXbWhOTUUwd1QxWnNiRlpYUlRCVWJVWlRVekZPVjJFd01VOVpibEpTWWpCYVdscHFhRlJPUlVVeFRtc3dlbGxXV2pGVGJVWlVZVEpXU1U1Vk5VdGhNSFJDVDBaa1lWTkhiRzlrTVVWNFlXMDVObUZYWkhwa2FrNTBVbGMxUkdGclVsSmxSbEp5VFRBeGVrOVhjSFZXZW1SdllWZHNkRlJyVWxwVmJscDVXVEJ2TkZKV1FrZGhTRTVPVmtoR2NXUlZaRTVQUjFaWlUwZE9NbVZFVFRWTlZHaEZaV3hLY0dWclVuZFVibHBvWW14V1QyUlZXblpWVlhoVFdUTndibVF3WkZaYVZXaFRXVmRWTVdFemFGcGlWR1IxWWpGR2FXRkhiRk5sYTNBeFRXcG9NMkpYT1ZkT1NHUkZVbFJqTkUweVNqTlRNakZUVDFWV2VtRkdWalpoYlRsclZFYzFTVmxZVWxkWk1qVklWbGM1Ymxwc2JIQmhiVkpHVjJwR1MxcFZkSFZqU0ZaeVYwaGFkMGxwZDJsYVdHaDNTV3B2ZWsxcVkzcE9hazB3VG5wVk1VMXBkMmxhYlU0d1NXcHdZbGhUZDJsaFdFNTZTV3B2YVZwSGJHdFBiV3gyWW1wd1JtRlZVVEJVVkVvd1kydGtjMlJIVWpOak1VWk9XVEJSTVZReFZUQmhSbWhMWld0b1lWSjZTbWhhTWpVeVltdGplRkZ1YUZkVWJsWmFUMWR3VWtscGQybGliVXB0U1dwdmVFNXFUWGxOZWxFelRrUnJlVXhEU25kamJWbHBUMjAxTVdKSGQzTkpia0l3V1hsSk5rbHNUbFpWUlZaVFdERldWRkpXU1dsTVEwcDVZekpOYVU5cFNYRkpiakF1YlU5NWRGOUJZVEZ6T0hkWlVFNW1XR3hJYlhWcGEzaE1Sa2wwTW1zMUxUaDFRM0JpUkV4d2JYZzVVMFJJYWtKd2RHVnhlR1V4TVRWbVJIVlhkRW90U1RKcFZYTTVlRXhQVlRsbk0xWnZZWE40YjAxeFFYY2lMQ0p3ZEdNaU9pSkJVRkJGVGtRaUxDSnljMk1pT2lJcUluMC5TVEFsQmJwajQ1Ykw1VG43akx5RVgwSW9RZnFWQmFNU2dwRVBlMEQ1blk1UGhPQWVReDN1ZWNxNW5DeER0dkd2RGJ2bXdTcW1SWnlTcUZhc1F4cEdCcTRORXJDaFEtMkVrMFZaWVRHSk5tVEJ1Um5peUtDR2szZFBtMExhemJ2aHVKVENMV2NxRVNteTRoeTNNOE1zaGRGNTBHRi0wUmVxa0RLejhiMjZUSExqczdCWXdtU2dmQWxQclIzNU5DaXpuZTF1RlNVWEJWLUdCajI4WklUOGVITEJUeUdaMzhWeWZrVmhDeHRNcExzTnh0eV9abm4yWURJWHdDUlkxU3U3NkY5eXV3MlhvQjNvbEZLOTZuQTNTRmprWExIUGtLVjVQT2UxVjlpYkltUmlobEZIRWVjdHRRZXdEWkVJeXAtaTZfc0cwRmZUNDd1VVNiQ0c2bks2dGciLCJwdGMiOiJBUFBFTkQiLCJyc2MiOiIqIn0"

ionRaw3 :: ByteString
ionRaw3 = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsInVhdiI6IjEuMC4wIn0.eyJhdWQiOiJkaWQ6a2V5OnpTdEVacHpTTXRUdDlrMnZzemd2Q3dGNGZMUVFTeUExNVc1QVE0ejNBUjZCeDRlRko1Y3JKRmJ1R3hLbWJtYTQiLCJleHAiOjE2MzIzNDc1ODksImZjdCI6W10sImlzcyI6ImRpZDprZXk6ejEzVjNTb2cyWWFVS2hkR0NtZ3g5VVp1VzFvMVNoRkpZYzZEdkdZZTdOVHQ2ODlOb0wyUlN1ZWNDMlFnalVIcGlvN3FNRHdxTXNNY21QZXRTdHdZR1ptdnlSSENBclBaQ3pjTEVpUTNVeERLYzFaV0d4MjZmRFlndkRLQktWYm5GbzNzRHNSQWU2TkN5dWlETlEyQmp2NGl0cEN3YkNHdVRaYm0zdmJpU2ZkYzZONXBOMzl5Z1NvRmEzQzQ5WWVVYTROYVJLU1ZrTU5idFFvRllmOFM0QTU2TTNhVnVKYVNrZUg1TkprS0E4V1pIaWh3UTFqb3ppZ3N2M21FbkNqRFF4VGszTXM5am5XN2hpaW1ORFlSdnJjSjhFUEZoc01UcWp1R004ZVhIY3Z4MzkxOER6Uml6RHBOdmFuVU51Rm9RTFJjemd3R1VlSFJhZTVreFltN25vUWJoaVJ6SnUyOHdtb1Y0d0RFNzgzYndLbVI5RXNoVXpqb2RMbkhhdFZjbkdVb2dmWWlqZEVaMUplS25wdWtYdnAiLCJuYmYiOjE2MzIzNDc1MDAsInByZiI6ImV5SmhiR2NpT2lKU1V6STFOaUlzSW5SNWNDSTZJa3BYVkNJc0luVmhkaUk2SWpFdU1DNHdJbjAuZXlKaGRXUWlPaUprYVdRNmEyVjVPbm94TTFZelUyOW5NbGxoVlV0b1pFZERiV2Q0T1ZWYWRWY3hiekZUYUVaS1dXTTJSSFpIV1dVM1RsUjBOamc1VG05TU1sSlRkV1ZqUXpKUloycFZTSEJwYnpkeFRVUjNjVTF6VFdOdFVHVjBVM1IzV1VkYWJYWjVVa2hEUVhKUVdrTjZZMHhGYVZFelZYaEVTMk14V2xkSGVESTJaa1JaWjNaRVMwSkxWbUp1Um04emMwUnpVa0ZsTms1RGVYVnBSRTVSTWtKcWRqUnBkSEJEZDJKRFIzVlVXbUp0TTNaaWFWTm1aR00yVGpWd1RqTTVlV2RUYjBaaE0wTTBPVmxsVldFMFRtRlNTMU5XYTAxT1luUlJiMFpaWmpoVE5FRTFOazB6WVZaMVNtRlRhMlZJTlU1S2EwdEJPRmRhU0dsb2QxRXhhbTk2YVdkemRqTnRSVzVEYWtSUmVGUnJNMDF6T1dwdVZ6ZG9hV2x0VGtSWlVuWnlZMG80UlZCR2FITk5WSEZxZFVkTk9HVllTR04yZURNNU1UaEVlbEpwZWtSd1RuWmhibFZPZFVadlVVeFNZM3BuZDBkVlpVaFNZV1UxYTNoWmJUZHViMUZpYUdsU2VrcDFNamgzYlc5V05IZEVSVGM0TTJKM1MyMVNPVVZ6YUZWNmFtOWtURzVJWVhSV1kyNUhWVzluWmxscGFtUkZXakZLWlV0dWNIVnJXSFp3SWl3aVpYaHdJam94TmpNeU16UTNOVGc1TENKbVkzUWlPbHRkTENKcGMzTWlPaUprYVdRNmEyVjVPbm94TTFZelUyOW5NbGxoVlV0b1pFZERiV2Q0T1ZWYWRWY3hiekZUYUVaS1dXTTJSSFpIV1dVM1RsUjBOamc1VG05TU1sSlRkV1ZqUXpKUloycFZTSEJwYnpkeFRVUjNjVTF6VFdOdFVHVjBVM1IzV1VkYWJYWjVVa2hEUVhKUVdrTjZZMHhGYVZFelZYaEVTMk14V2xkSGVESTJaa1JaWjNaRVMwSkxWbUp1Um04emMwUnpVa0ZsTms1RGVYVnBSRTVSTWtKcWRqUnBkSEJEZDJKRFIzVlVXbUp0TTNaaWFWTm1aR00yVGpWd1RqTTVlV2RUYjBaaE0wTTBPVmxsVldFMFRtRlNTMU5XYTAxT1luUlJiMFpaWmpoVE5FRTFOazB6WVZaMVNtRlRhMlZJTlU1S2EwdEJPRmRhU0dsb2QxRXhhbTk2YVdkemRqTnRSVzVEYWtSUmVGUnJNMDF6T1dwdVZ6ZG9hV2x0VGtSWlVuWnlZMG80UlZCR2FITk5WSEZxZFVkTk9HVllTR04yZURNNU1UaEVlbEpwZWtSd1RuWmhibFZPZFVadlVVeFNZM3BuZDBkVlpVaFNZV1UxYTNoWmJUZHViMUZpYUdsU2VrcDFNamgzYlc5V05IZEVSVGM0TTJKM1MyMVNPVVZ6YUZWNmFtOWtURzVJWVhSV1kyNUhWVzluWmxscGFtUkZXakZLWlV0dWNIVnJXSFp3SWl3aWJtSm1Jam94TmpNeU16UTNORGs1TENKd2NtWWlPaUpsZVVwb1lrZGphVTlwU2taYVJWSlVVVk5KYzBsdVVqVmpRMGsyU1d0d1dGWkRTWE5KYmxab1pHbEpOa2xxUlhWTlF6UjNTVzR3TG1WNVNtaGtWMUZwVDJsS2EyRlhVVFpoTWxZMVQyNXZlRTB4V1hwVk1qbHVUV3hzYUZaVmRHOWFSV1JFWWxka05FOVdWbUZrVm1ONFlucEdWR0ZGV2t0WFYwMHlVa2hhU0ZkWFZUTlViRkl3VG1wbk5WUnRPVTFOYkVwVVpGZFdhbEY2U2xKYU1uQldVMGhDY0dKNlpIaFVWVkl6WTFVeGVsUlhUblJWUjFZd1ZUTlNNMWRWWkdGaVdGbzFWV3RvUkZGWVNsRlhhMDQyV1RCNFJtRldSWHBXV0doRlV6Sk5lRmRzWkVobFJFa3lXbXRTV2xveldrVlRNRXBNVm0xS2RWSnRPSHBqTUZKNlZXdEdiRTVyTlVSbFdGWndVa1UxVWsxclNuRmthbEp3WkVoQ1JHUXlTa1JTTTFaVlYyMUtkRTB6V21saFZrNXRXa2ROTWxScVZuZFVhazAxWlZka1ZHSXdXbWhOTUUwd1QxWnNiRlpYUlRCVWJVWlRVekZPVjJFd01VOVpibEpTWWpCYVdscHFhRlJPUlVVeFRtc3dlbGxXV2pGVGJVWlVZVEpXU1U1Vk5VdGhNSFJDVDBaa1lWTkhiRzlrTVVWNFlXMDVObUZYWkhwa2FrNTBVbGMxUkdGclVsSmxSbEp5VFRBeGVrOVhjSFZXZW1SdllWZHNkRlJyVWxwVmJscDVXVEJ2TkZKV1FrZGhTRTVPVmtoR2NXUlZaRTVQUjFaWlUwZE9NbVZFVFRWTlZHaEZaV3hLY0dWclVuZFVibHBvWW14V1QyUlZXblpWVlhoVFdUTndibVF3WkZaYVZXaFRXVmRWTVdFemFGcGlWR1IxWWpGR2FXRkhiRk5sYTNBeFRXcG9NMkpYT1ZkT1NHUkZVbFJqTkUweVNqTlRNakZUVDFWV2VtRkdWalpoYlRsclZFYzFTVmxZVWxkWk1qVklWbGM1Ymxwc2JIQmhiVkpHVjJwR1MxcFZkSFZqU0ZaeVYwaGFkMGxwZDJsYVdHaDNTV3B2ZWsxcVkzcE9hazB3VG5wVk1VMXBkMmxhYlU0d1NXcHdZbGhUZDJsaFdFNTZTV3B2YVZwSGJHdFBiV3gyWW1wd1JtRlZVVEJVVkVvd1kydGtjMlJIVWpOak1VWk9XVEJSTVZReFZUQmhSbWhMWld0b1lWSjZTbWhhTWpVeVltdGplRkZ1YUZkVWJsWmFUMWR3VWtscGQybGliVXB0U1dwdmVFNXFUWGxOZWxFelRrUnJlVXhEU25kamJWbHBUMjAxTVdKSGQzTkpia0l3V1hsSk5rbHNUbFpWUlZaVFdERldWRkpXU1dsTVEwcDVZekpOYVU5cFNYRkpiakF1YlU5NWRGOUJZVEZ6T0hkWlVFNW1XR3hJYlhWcGEzaE1Sa2wwTW1zMUxUaDFRM0JpUkV4d2JYZzVVMFJJYWtKd2RHVnhlR1V4TVRWbVJIVlhkRW90U1RKcFZYTTVlRXhQVlRsbk0xWnZZWE40YjAxeFFYY2lMQ0p3ZEdNaU9pSkJVRkJGVGtRaUxDSnljMk1pT2lJcUluMC5TVEFsQmJwajQ1Ykw1VG43akx5RVgwSW9RZnFWQmFNU2dwRVBlMEQ1blk1UGhPQWVReDN1ZWNxNW5DeER0dkd2RGJ2bXdTcW1SWnlTcUZhc1F4cEdCcTRORXJDaFEtMkVrMFZaWVRHSk5tVEJ1Um5peUtDR2szZFBtMExhemJ2aHVKVENMV2NxRVNteTRoeTNNOE1zaGRGNTBHRi0wUmVxa0RLejhiMjZUSExqczdCWXdtU2dmQWxQclIzNU5DaXpuZTF1RlNVWEJWLUdCajI4WklUOGVITEJUeUdaMzhWeWZrVmhDeHRNcExzTnh0eV9abm4yWURJWHdDUlkxU3U3NkY5eXV3MlhvQjNvbEZLOTZuQTNTRmprWExIUGtLVjVQT2UxVjlpYkltUmlobEZIRWVjdHRRZXdEWkVJeXAtaTZfc0cwRmZUNDd1VVNiQ0c2bks2dGciLCJwdGMiOiJBUFBFTkQiLCJyc2MiOiIqIn0.B4l1gRWvM8BJ8xlmD88Cibl4eNxBydJsm3vZzJVq1zzSfMMfbRXWiB--0tY2u_c42zp297gamHeOjKTsyg3-tlJWDGxA5puss46gqxyWTY-KPW7eBElCzuQ_Otkxhq9AlasrggUdkZBWYe9Xp6XBYOgSQbXEuStX8wGN48CsCtH31ULzVrAsfPmbgoAud5hfQWt4byPBFmBdQKPCNwVg50liSLL72zWd1PKhud8a2v1TWEX2X_CJhzo404rwrLCz9ckUkoOEk5PNgZkJrP3OUAZSiEHluTk__c66IOarXttzRymxl5C8HcwNltlXQtPTGcuaXARWvp-pOXDtgCiL7Q"

ionUCAN3 :: JWT
Just ionUCAN3 = JSON.decodeStrict ("\""<> ionRaw3 <> "\"")

import {expect } from "chai";
import {ethers,network} from "hardhat";
import { createInstances } from "../instance";
import { initSigners, getSigners } from "../signers";
import { awaitAllDecryptionResults } from "../asyncDecrypt";

describe ("CrypticClue Tests", function (){
    before (async function(){
        await initSigners();
        this.signers = await getSigners();
        this.relayerAddress = "0x97F272ccfef4026A1F3f0e0E879d514627B84E69";
    });

    beforeEach(async function(){
        const contractFactory = await ethers.getContractFactory("CrypticClue");
        this.contract = await contractFactory.connect(this.signers.alice).deploy();
        await this.contract.waitForDeployment();
        this.contractAddress = await this.contract.getAddress();
        this.instances = await createInstances(this.signers);

    });

    it('should be able to get the address of player', async function(){

        const input = this.instances.alice.createEncryptedInput(this.contractAddress, this.signers.alice.address);
        input.addAddress("0xa5e1defb98EFe38EBb2D958CEe052410247F4c80");
        const encrypted = input.encrypt();
        const tx = await this.contract["inputAddress(bytes32,bytes)"](
            encrypted.handles[0],
            encrypted.inputProof,
        );

        await tx.wait();
        // expect(tx).to.equal(true);
        const tx1 = await this.contract.connect(this.signers.alice).decryptPlayer({ gasLimit: 5_000_000 });
        await tx1.wait();
        await awaitAllDecryptionResults();
        const y = await this.contract._player1();
        expect(y).to.equal("0xa5e1defb98EFe38EBb2D958CEe052410247F4c80");


    });

    // it('again should be able to get the address of player', async function(){

        // const input = this.instances.alice.createEncryptedInput(this.contractAddress, this.signers.alice.address);
        // input.addAddress("0xa5e1defb98EFe38EBb2D958CEe052410247F4c80");
        // const encrypted = input.encrypt();
        // const tx = await this.contract["inputAddress(bytes32,bytes)"](
        //     encrypted.handles[0],
        //     encrypted.inputProof,
        // );

        // await tx.wait();
        
        


    // });



});
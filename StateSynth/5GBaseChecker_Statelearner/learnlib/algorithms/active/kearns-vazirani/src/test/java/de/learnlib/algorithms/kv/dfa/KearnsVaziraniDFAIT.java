/* Copyright (C) 2013-2022 TU Dortmund
 * This file is part of LearnLib, http://www.learnlib.de/.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package de.learnlib.algorithms.kv.dfa;

import de.learnlib.acex.analyzers.AbstractNamedAcexAnalyzer;
import de.learnlib.acex.analyzers.AcexAnalyzers;
import de.learnlib.api.oracle.MembershipOracle.DFAMembershipOracle;
import de.learnlib.testsupport.it.learner.AbstractDFALearnerIT;
import de.learnlib.testsupport.it.learner.LearnerVariantList.DFALearnerVariantList;
import net.automatalib.words.Alphabet;
import org.testng.annotations.Test;

/**
 * Function test for the Kearns/Vazirani algorithm for DFA learning.
 *
 * @author Malte Isberner
 */
@Test
public class KearnsVaziraniDFAIT extends AbstractDFALearnerIT {

    private static final boolean[] BOOLEAN_VALUES = {false, true};

    @Override
    protected <I> void addLearnerVariants(Alphabet<I> alphabet,
                                          int targetSize,
                                          DFAMembershipOracle<I> mqOracle,
                                          DFALearnerVariantList<I> variants) {
        KearnsVaziraniDFABuilder<I> builder = new KearnsVaziraniDFABuilder<>();
        builder.setAlphabet(alphabet);
        builder.setOracle(mqOracle);

        for (boolean repeatedEval : BOOLEAN_VALUES) {
            builder.setRepeatedCounterexampleEvaluation(repeatedEval);

            for (AbstractNamedAcexAnalyzer acexAnalyzer : AcexAnalyzers.getAllAnalyzers()) {
                builder.setCounterexampleAnalyzer(acexAnalyzer);
                String name = String.format("repeatedEval=%s,ceAnalyzer=%s", repeatedEval, acexAnalyzer.getName());
                variants.addLearnerVariant(name, builder.create());
            }
        }
    }

}

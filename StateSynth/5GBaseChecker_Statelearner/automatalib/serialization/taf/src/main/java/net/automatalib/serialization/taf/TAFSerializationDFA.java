/* Copyright (C) 2013-2022 TU Dortmund
 * This file is part of AutomataLib, http://www.automatalib.net/.
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
package net.automatalib.serialization.taf;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Writer;

import net.automatalib.automata.fsa.DFA;
import net.automatalib.automata.fsa.impl.compact.CompactDFA;
import net.automatalib.commons.util.IOUtil;
import net.automatalib.serialization.InputModelData;
import net.automatalib.serialization.InputModelSerializationProvider;
import net.automatalib.serialization.taf.parser.PrintStreamDiagnosticListener;
import net.automatalib.serialization.taf.parser.TAFParser;
import net.automatalib.serialization.taf.writer.TAFWriter;
import net.automatalib.words.Alphabet;

public final class TAFSerializationDFA
        implements InputModelSerializationProvider<String, DFA<?, String>, DFA<Integer, String>> {

    private static final TAFSerializationDFA INSTANCE = new TAFSerializationDFA();

    private TAFSerializationDFA() {}

    public static TAFSerializationDFA getInstance() {
        return INSTANCE;
    }

    @Override
    public void writeModel(OutputStream os, DFA<?, String> model, Alphabet<String> alphabet) throws IOException {
        try (Writer w = IOUtil.asBufferedNonClosingUTF8Writer(os)) {
            TAFWriter.writeDFA(model, alphabet, w);
        }
    }

    @Override
    public InputModelData<String, DFA<Integer, String>> readModel(InputStream is) throws IOException {
        final CompactDFA<String> automaton =
                TAFParser.parseDFA(is, PrintStreamDiagnosticListener.getStderrDiagnosticListener());
        return new InputModelData<>(automaton, automaton.getInputAlphabet());
    }
}
